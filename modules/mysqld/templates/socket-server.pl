#!/usr/bin/perl -T
#
#                  Copyright (C) 2006 Zmanda Incorporated.
#                            All Rights Reserved.
#
#  The software you have just accessed, its contents, output and underlying
#  programming code are the proprietary and confidential information of Zmanda
#  Incorporated.  Only specially authorized employees, agents or licensees of
#  Zmanda may access and use this software.  If you have not been given
#  specific written permission by Zmanda, any attempt to access, use, decode,
#  modify or otherwise tamper with this software will subject you to civil
#  liability and/or criminal prosecution to the fullest extent of the law.
#

# This is meant to be invoked by xinetd.
# It expects two arguments on stdin
# First argument is the action to be taken. 
# Valid actions are 'mysqlhotcopy', 'copy to', 'copy from'
# Second argument is the parameter list if mysqlhotcopy is the action specified
# or the file that needs to be copied if the action is copy.
# It will output the data on stdout after being uuencoded
# so that we only transfer ascii data.
# Each data block is preceeded by the size of the block being written.
# This date is encoded in Network order
# Remember that the communication is not secure and that this can be used to 
# copy arbitary data from the host.
# Log messages can be found in /var/log/mysql-zrm/socket-server.log 
# on the MySQL server

use strict;

use File::Path;
use File::Basename;
use File::Temp qw/ :POSIX /;

# Set remote-mysql-binpath in mysql-zrm.conf if mysql client binaries are 
# in a different location
my $MYSQL_BINPATH = "/usr/bin";

# File pointed to here is expected to contain the alternate path 
# where plugins are installed.
# If file is not found the path /usr/share/mysql-zrm/plugins is used
my $SNAPSHOT_INSTALL_CONF_FILE = "/etc/mysql-zrm/plugin-path";

delete @ENV{'IFS', 'CDPATH', 'ENV', 'BASH_ENV'};
$ENV{PATH}="/usr/local/bin:/opt/csw/bin:/usr/bin:/usr/sbin:/bin:/sbin";
my $TAR = "tar";
my $LS = "ls";

my $TMPDIR;
my $tmp_directory;
my $action;
my $params;
my $MYSQLHOTCOPY="mysqlhotcopy";
my $VERSION="1.9";
my $logDir = "/var/log/mysql-zrm";
my $logFile = "$logDir/socket-server.log";
my $snapshotInstallPath = "/usr/share/mysql-zrm/plugins";
my $compress = "";
my $MYSQLADMIN="mysqladmin";
my $verbose = 0;
my $logparams = "";
my $mysqllogdir = "/sql/log";

open LOG, ">>$logFile" or die "Unable to create log file";
$SIG{'PIPE'} = sub { &printAndDie( "pipe broke\n" ); };

# This will only allow and a-z A-Z 0-9 _ - / . = " ' ; + * and space.
# Modify this if any other characters are to be allowed.
sub checkIfTainted(){
        if( $_[0] =~ /^([-\*\w\/"\'.\:\+\s=@\^\$]+)$/) {
                return $1;
        }else{
                &printAndDie("Bad data in $_[0]\n");
        }
}

sub my_exit(){
	if( $tmp_directory ){
		rmtree $tmp_directory, 0, 0;
	}
	exit( $_[0] );
}

sub printLog()
{
	my $lognote=$_[0];
	$lognote=~s/-password=([^\s]*)/-password="*****"/;
	chomp($lognote);
	my $log_date = localtime;
	print LOG "$log_date: $lognote\n";
}

sub printAndDie()
{
	&printLog( "ERROR: $_[0]" );
	#in case of verify send it to the server
	if($action eq "verify-config"){
		&printToServer( "ERROR", $_[0] );
	}
	&my_exit( 1 );
}

sub checkForTarErrors()
{
my $tarOutFile = $_[0];
my $set_error = 0;
        if(-e $tarOutFile) {
                unless(open(TAR_OUT, $tarOutFile)) {
                   &printandDie( "Could not open $tarOutFile for reading ,$!\n" );
                }
                unless (open(TAR_WAR,"/usr/share/mysql-zrm/plugins/tar_warnings.txt")) {
                   &printandDie( "Could not open /usr/share/mysql-zrm/plugins/tar_warnings.txt  for reading ,$!\n" );
                }
                my @tarwar = (<TAR_WAR>); #Get tar normal warnigns list
                while (<TAR_OUT>) {
                  foreach my $line (@tarwar) {  
                        if($_ =~ /$line/i) {
                                &printLog("Ignoring Tar warnings found on STDERR : $_ \n");
                                last;
                        } else {
                                &printLog("ERROR : Tar STDERR found  : $_ \n");
                                $set_error = 1;
                        }
                  }
                }
        }
	return $set_error;
}

sub getInputs()
{
	my @inp;
	my $x = <STDIN>;
	chomp( $x );
	$x = &checkIfTainted($x);
	if( $x ne $VERSION ){
		&printAndDie( "Version of remote copy plugin does not match\n" );
	}
	#checking for verbose
	my $chkverbose  = <STDIN>;
	chomp( $chkverbose );
	$chkverbose = &checkIfTainted($chkverbose);
        if($chkverbose){
                $verbose = 1;
        	&printLog( "verbose enabled \n" );
        }

	for( my $i = 0; $i < 5; $i++ ){
		$x = <STDIN>;
		push @inp, $x;	
	}
	chomp( @inp );
	$action = &checkIfTainted($inp[0]);
	$params = &checkIfTainted($inp[1]);
	$TMPDIR = &checkIfTainted($inp[2]);
	$MYSQL_BINPATH = &checkIfTainted($inp[3]);
	if( $inp[4] ne "" ){
		$compress = &checkIfTainted($inp[4]);
	}
	if($verbose)
	{
		$logparams = $params;
		$logparams=~s/-password=("[^"]*")/-password="*****"/;
		&printLog("Listening the following values from socket\n");
		&printLog("Input: action = $action \n");
		&printLog("Input: params = $logparams \n");
		&printLog("Input: TMPDIR = $TMPDIR \n");
		&printLog("Input: MYSQL_BINPATH = $MYSQL_BINPATH \n");
		if( $inp[4] ne "" ){
		&printLog("Input: compress = $compress \n");
		}
	}

	
}

sub doHotCopy()
{
	&printLog("checking for mysqlhotcopy path: $MYSQL_BINPATH/$MYSQLHOTCOPY\n");
	if( ! -d $MYSQL_BINPATH || ! -f "$MYSQL_BINPATH/$MYSQLHOTCOPY" ){
		&printAndDie( "mysqlhotcopy not found\n" );
	}

	$logparams = $params;
	$logparams=~s/-password=("[^"]*")/-password="*****"/;
	if($verbose){
		&printLog("command used mysqlhotcopy : $MYSQL_BINPATH/$MYSQLHOTCOPY $logparams $tmp_directory 2>>$logFile\n");
	}

	my $r = system( "$MYSQL_BINPATH/$MYSQLHOTCOPY $params $tmp_directory 2>>$logFile" );
	if( $r > 0 ){
		&printAndDie( "mysqlhotcopy : $MYSQL_BINPATH/$MYSQLHOTCOPY $logparams $tmp_directory 2>>$logFile failed with following $!\n" );
	}
}

#$_[0] dirname
#$_[1] filename
sub writeTarStream()
{
        my $fileList = $_[1];
        my $lsCmd = "";

        my $tmpFile = getTmpName();

        if( $_[1] =~ /\*/){
		$lsCmd = "cd $_[0]; $LS -1 $_[1] > $tmpFile 2>>$logFile;";
		if($verbose){
			&printLog("command used for LSCMD: : $lsCmd\n");
		}
		my $r = system( $lsCmd );
                $fileList = " -T $tmpFile";
		if( $r > 0 ){
			&printAndDie( "LSCMD command: $lsCmd failed with following error $!\n" );                 
		}
		if($verbose){
			my $list_tmpFile = `cat $fileList`;
			&printLog( "Contents of tmpFile: $list_tmpFile " );
		}
        }

 	my $tarOutFile = getTmpName();
	if($verbose){
		&printLog("Creating TAR in writeTarStream : CMD used : $TAR --same-owner $compress -cphsC $_[0] $fileList 2>$tarOutFile\n");
	}
	unless(open( TAR_H, "$TAR --same-owner $compress -cphsC $_[0] $fileList 2> $tarOutFile|" ) ){
		&printandDie( "TAR failed in writeTarStream $!\n" );
	}
	binmode( TAR_H );
	my $buf;
        while( read( TAR_H, $buf, 10240 ) ){
                my $x = pack( "u*", $buf );
		print pack( "N", length( $x ) );
		print $x;
        }
	if( $lsCmd ){
		unlink( $tmpFile );
	}
        if(&checkForTarErrors($tarOutFile) || !close(TAR_H)){
		unlink($tarOutFile) if(-e $tarOutFile);
                &printAndDie( "Tar output found Errors, exiting \n" );
        }
}

#$_[0] dirname to strea the data to
sub readTarStream()
{
	my $tarOutFile = getTmpName();
	if($verbose){
		&printLog("Reading TAR stream in readTarStram : |$TAR --same-owner $compress -xphsC $_[0] 2>$tarOutFile\n");
	}
	unless(open( TAR_H, "|$TAR --same-owner $compress -xphsC $_[0] 2>$tarOutFile" ) ){
		&printandDie( "Tar failed in readTarStream $!\n" );
	}

        my $buf;
        # Initially read the length of data to read
        # This will be packed in network order
        # Then read that much data which is uuencoded
        # Then write the unpacked data to tar
        while( read( STDIN, $buf, 4 ) ){
                $buf = unpack( "N", $buf );
                read STDIN, $buf, $buf;
                print TAR_H unpack( "u", $buf );
        }
   	if( &checkForTarErrors($tarOutFile) || !close(TAR_H) ){
		unlink($tarOutFile) if(-e $tarOutFile);
                &printAndDie( "Tar output found Errors, exiting \n" );
        }
}

sub getTmpName()
{
	if( ! -d $TMPDIR ){
		&printAndDie( "$TMPDIR not found. Please create this first.\n" );
	}
	&printLog( "TMP directory being used is $TMPDIR\n" );
	my $temp_return = File::Temp::tempnam( $TMPDIR, "" );  
	if($verbose){
	&printLog( "Return from File::Temp::tempnam $temp_return \n" );
	}
	return $temp_return;
}


sub removeBackupData()
{
	&printLog("Removing backup data\n");
	my @sp = split /\s/, $params;
	my $id = $sp[0];
	shift @sp;
	my $dir = join( /\s/, @sp );
	my $orig = $dir;
	if( $id eq "LINKS" ){
		$dir .= "/ZRM_LINKS";
	}elsif( $id eq "MOUNTS" ){
		$dir .= "/ZRM_MOUNTS";
		if( ! -d $dir ){
			if($verbose){
			&printLog("Directory $dir not found\n");
			}
			return;
		}
	}else{
		$dir .= "/BACKUP/BACKUP-$id";
	}

	if($verbose){
		&printLog("Removing dir : $dir\n");
	}
	rmtree $dir, 0, 0;
	if( $id eq "MOUNTS" ){
		if($verbose){
		&printLog("Removing mount dir : $orig \n");
		}
		rmdir $orig;
	}
}

sub validateSnapshotCommand()
{
        &printLog( "Validating snapshot\n" );
	my $file = basename( $_[0] );
	if( -f $SNAPSHOT_INSTALL_CONF_FILE ){
		if( open( TMP, $SNAPSHOT_INSTALL_CONF_FILE ) ){
			$snapshotInstallPath = <TMP>;
			close TMP;
			chomp( $snapshotInstallPath );
		}	
	}
	else
	{
	if ($verbose){
			&printLog( "Custom plugin not used OR custom snapshot file not found at : $SNAPSHOT_INSTALL_CONF_FILE \n" );
		}
	}
	my $cmd = "$snapshotInstallPath/$file";
	if($verbose){
		&printLog( "SanpshotInstallPath: $snapshotInstallPath/$file and cmd: $cmd \n" );
	}
	if( -f $cmd ){
		return $cmd;
	}
	return "";	
}

sub printToServer()
{
	my @data = @_;
	my $status = shift @data;
	my $cnt = @data;
	&printLog( "status=$status\n" );
	print "$status\n";
	print "$cnt\n";
	my $i;
	for( $i = 0; $i < $cnt; $i++ ){
		&printLog( "$data[$i]\n" );
		print "$data[$i]\n";
	}
}

#$_[0] name of file
sub printFileToServer()
{
	my @x = "";
	if( open( TMP, $_[1] ) ){
		@x = <TMP>;
		close TMP;
		chomp( @x );
		&printToServer( $_[0], @x );	
	}	
}

sub doCreateLink()
{
        &printLog( "Creating link\n");
	my $num = &readOneLine();
	my $i;
	my $er = 0;
	for( $i = 0; $i < $num; $i += 2 ){
		my $p = &readOneLine();
		my $link = &readOneLine();
		eval { mkpath( $p, 0, 0700 ) };
		if ($@) {
			&printToServer( "ERROR", "Unable to create directory $p, $@" );
			&printAndDie( "Unable to create directory $p, $@ \n" );
		}

		my $cmd = "ln -s $link 2>>$logFile";
		if($verbose){
       			&printLog( "\n command used for creating link: $cmd\n" );
		}
		my $r = system( $cmd );
		if( $r != 0 ){
			$er = 1;
			&printFileToServer( "ERROR", "Could not create link." );
		}
	}
	if( $er == 0 ){
		&printFileToServer( "SUCCESS", "Link created." );	
	}
}

sub readOneLine()
{
	my $line = <STDIN>;
	chomp( $line );
	$line = &checkIfTainted( $line );
	return $line;
}

sub doSnapshotCommand()
{
        &printLog( "Creating snapshot\n" );
	my $cmd = &readOneLine();
	my $num = &readOneLine();

	my @confData;
	my $i;
	for( $i = 0; $i < $num;$i++ ){
		my $str = &readOneLine();
		push @confData, $str;	
	}

	if($verbose){
        	&printLog( "@confData" );
        	&printLog( "Command used for validating snapshot $cmd" );
	}
	my $command = &validateSnapshotCommand( $cmd );
	if($verbose){
       		&printLog( "ValidateSnapshotCommand returns: $command \n");
	}

	if( $command eq "" ){
		&printToServer( "ERROR", "Snapshot Plugin $cmd not found" );
		&printAndDie( "Snapshot Plugin $cmd not found\n" );
	}
	my $file = tmpnam();
	$file = basename( $file );
	$file = "$tmp_directory/$file";
	if( ! open( TMP, ">$file" ) ){
		&printToServer( "ERROR", "Unable to open temp file $file" );
		&printAndDie( "Unable to open temp file $file, $!\n" );
	}
	foreach( @confData ){
		print TMP "$_\n"; 	
	}
	close TMP;
	$ENV{'ZRM_CONF'} = $file;
	my $f = tmpnam();
	my $ofile = basename($f);
	$f = tmpnam();
	my $efile = basename($f);
	$command .= " $params > $tmp_directory/$ofile 2>$tmp_directory/$efile";
	if($verbose){
		&printLog( "Command used for snapshot: $command \n");
	}

	if (-s "$mysqllogdir/error.log-old") {
		# zmanda has already flushed logs, and will again after the snapshot
		# This code is here to save the flushed error.log.
		# The block below will restore it back into error.log.
		# FIXME: don't hardcode log path, but how to reliably get the error log from mysql?
		my $ret=rename("$mysqllogdir/error.log-old","$mysqllogdir/error.log-zmandatmp");
		&printLog( "preserved error.log-old: $? \n");
	}

	my $r = system( $command );

	if ( -s "$mysqllogdir/error.log-zmandatmp") {
		# Absolutely no error checking... the backup will probably blow up, but that's OK because
		# something is really wrong with the machine.
		open(READ,"$mysqllogdir/error.log-zmandatmp");
		open(WRITE,">$mysqllogdir/error.log");
		local $/;
		print WRITE <READ>;
		close(READ);
		close(WRITE);
		unlink("$mysqllogdir/error.log-zmandatmp");
		&printLog( "moved preserved error.log-old back to error.log ");
	}

	if( $r == 0 ){
		&printFileToServer( "SUCCESS", "$tmp_directory/$ofile" );	
	}else{
		&printFileToServer( "ERROR", "$tmp_directory/$efile" );
	}
}

sub doCopyBetween()
{
	$ENV{'TMPDIR'} = $TMPDIR;
	my $port = &readOneLine();
	my $f = tmpnam();
	$f = basename( $f );
	$f = "$tmp_directory/$f";		
	unless( open( T, ">$f" ) ){
		&printToServer( "ERROR", "Unable to open temp file $f" );
		&printAndDie( "Unable to open temp file $f, $!\n" );
	}
	print T "$port\n";
	close T;
	$ENV{'ZRM_CONF'}=$f;
	$f = tmpnam();
	my $ofile = basename($f);
	$f = tmpnam();
	my $efile = basename($f);
	my $cmd = "/usr/share/mysql-zrm/plugins/socket-copy.pl $params > $tmp_directory/$ofile 2>$tmp_directory/$efile";
	&printLog( "$cmd\n" );
	my $r = system( $cmd );
	if( $r == 0 ){
		&printFileToServer( "SUCCESS", "$tmp_directory/$ofile" );	
	}else{
		&printFileToServer( "ERROR", "$tmp_directory/$efile" );
	}
}

#verify the client.
#checking for the TEMP directory
#checking for mysql connection
sub verifyClient()
{
    &printLog("Verify Client \n");
    $tmp_directory=&getTmpName();
    my $r = mkdir( $tmp_directory, 0700 );
    if( $r == 0 ){
            &printAndDie( "Unable to create tmp directory $tmp_directory on remote host.\n$!\n" );
    }
    &printLog("TMP check succesfully \n");
    &printLog("Checking for mysql connection on remote machine.\n");
    my  $p = "$MYSQL_BINPATH/$MYSQLADMIN $params";
    my $command = "$p variables";
    my @a = `$command 2>&1`;
    chomp( @a );
    if( $? != 0 ){
                &printAndDie( "unable to connect mysql  @a\n");
    }
    &printLog("mysql succefully connected on remote host.\n");
}

&printLog( "Client started\n" );
select( STDIN );
$| = 1;
select( STDOUT );
$| = 1;
&getInputs();

if( $action eq "copy from" ){
	my @suf;
	my $file = basename( $params, @suf );
	my $dir = dirname( $params );
	&writeTarStream( $dir, $file );
}elsif( $action eq "copy between" ){
	$tmp_directory=&getTmpName();
	my $r = mkdir( $tmp_directory );
	if( $r == 0 ){
		&printAndDie( "Unable to create tmp directory $tmp_directory.\n$!\n" );
	}
	&doCopyBetween();
}elsif( $action eq "copy to" ){
	my $s = $params;
	$s =~ s/^"//;
	$s =~ s/"$//;
	if( ! -d $s ){
		&printAndDie( "$params not found\n" );
	}
	&readTarStream( $params );
}elsif( $action eq "mysqlhotcopy" ){
	$tmp_directory=&getTmpName();
	my $r = mkdir( $tmp_directory );
	if( $r == 0 ){
		&printAndDie( "Unable to create tmp directory $tmp_directory.\n$!\n" );
	}
	&doHotCopy( );
	&writeTarStream( $tmp_directory, "." );
}elsif( $action eq "remove-backup-data" ){
	&removeBackupData();
}elsif( $action eq "snapshot" ){
	$tmp_directory=&getTmpName();
	my $r = mkdir( $tmp_directory, 0700 );
	if( $r == 0 ){
		&printAndDie( "Unable to create tmp directory $tmp_directory.\n$!\n" );
	}
	&doSnapshotCommand( $tmp_directory );
}elsif( $action eq "create-link" ){
	&doCreateLink();
}elsif( $action eq "verify-config"){
    	&verifyClient();
}else{
	&printAndDie( "Unknown action $action\n" );
}
&printLog( "Client clean exit\n\n" );
&my_exit( 0 );

