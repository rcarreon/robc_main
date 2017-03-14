#!/usr/bin/mysql-zrm-perl
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

use strict;
use warnings;
use Getopt::Long;
use File::Path;
use lib '/usr/lib/mysql-zrm';
use ZRM::SnapshotCommon;

use lib '/usr/lib/mysql-zrm';
BEGIN { 
	my $module = "NaServer";
	my $return = eval "use base qw($module)";
	if($@){
		die "Could not Load Module $module, please install the NetApp ONTAPI server module \n"; 
    	}
}


$SIG{'TERM'} = sub { &printAndDie("TERM signal"); };

# $Admin and $Password contain the root/password of NetApp Filer
# Read from the configuration file.
my $Admin    = "";
my $Password = "";

#Sets up relavent config parameters
sub setUpConfParams()
{
        if( $config{"netapp-user"} ){
                $Admin=$config{"netapp-user"};
        } else {
                &printAndDie( "Failed to get the netapp-user");     
        }

        if( $config{"netapp-password"} ){
                $Password=$config{"netapp-password"};
        } else {
                &printAndDie( "Failed to get the netapp-password");     
        }
}

# Uses df to get the device name and filesystem type
# $_[0] directory name
# $_[1] snapshot name
sub getSnapshotDeviceDetails()
{
	my $cmd;
	if($verbose){
                &printLog("Getting SnapshotDeviceDetails.\n");
        }

	my $snapshotName = $_[1];
	$cmd = "sudo $DF $_[0] 2>$LOGGER";

	if($verbose){
                &printLog("Command used : $cmd\n");
        }

        my @ret = `$cmd`;
        if( $? != 0 ) {
		&printCommandOutputToSnapshotLog( "ERROR", "Failed to find database with cmd : $cmd", $LOGGER );
        }

	chomp( @ret );
        # $ret[0] contains headers, ignore it.
        my @fs = split(" " , $ret[1]);
	if($verbose){
                &printLog("df command output : \n");
                &printLog("$ret[0] \n");
                &printLog("$ret[1] \n");
        }

        my $dev = "$fs[0]/";
        my $snapDevName;

        if ( $fs[1] =~ /nfs/ ) {
                my $Filer;
                my $vol_name;
		# regexp used below expects a trailing '/'
		if( ! ($dev =~ /\/$/) ){
			$dev .= "/";
		}
                # All Netapp volumes start with /vol/<volname>
                if( $dev =~ /(\S+):\/+vol\/+(\S+?)\/(.*)/ ){
                        $Filer = $1;
                        $vol_name = $2;

                        $dev = "$Filer:/vol/$vol_name";
                        $snapDevName = "$dev/.snapshot/$snapshotName";
                        print "device=$dev\n";
                        print "snapshot-device=$snapDevName\n";
                        print "device-mount-point=$fs[6]\n";
                        print "filesystem-type=$fs[1]\n";
			if($verbose) {
                		&printLog("device=$dev\n");
                		&printLog("snapshot-device=$snapDevName\n");
                		&printLog("device-mount-point=$fs[6]\n");
                		&printLog("filesystem-type=$fs[1]\n");
			}
                        my $str = &getCommonDetails( $_[0], $_[1], $fs[6] );
			# If $3 is present, relative path needs to be 
			# prepended with $3 to point to the right path.
			if( ! defined $3 ){
                        	print $str;
                        	&printLog("$str") if($verbose);
			}else{
				my @s = split /\n/, $str;
				print "$s[0]\n";
                        	&printLog("$s[0]\n") if($verbose);
				my @a = split /=/, $s[1];
				$a[1] = &removeExtraSlashesFromPath( "$3/$a[1]" );
				print "$a[0]=$a[1]\n";
                        	&printLog("$a[0]=$a[1]\n") if($verbose);
			}
                } else {
                        &printAndDie( "$dev not a Netapp volume\n" );
                }
        } else {
                &printAndDie( "$dev not NFS mounted\n" );
        }
}


sub doGetSnapshotdeviceDetails()
{
	if( !defined $opt{"directory"} ){
		&printAndDie( "Please supply --directory" );
	} 
	if( !defined  $opt{"sname"} ) {
		&printAndDie( "Please supply --sname" );
	}
	&getSnapshotDeviceDetails( $opt{"directory"}, $opt{"sname"} );
}


sub doCreateSnapshot()
{
	if($verbose){
		&printLog("Creating snapshot\n");
	}
	if( !defined $opt{"dev"} ){
		&printAndDie( "Please input --dev" );
	}
	if( !defined $opt{"sname"} ){
		&printAndDie( "Please input --sname" );
	}
 

        my $Filer;
        my $volName;        

        my $snapName = $opt{"sname"};
        
        # 20140304 (sdejean) - Adding snapmirror functionality, please see:
        # https://agilezen.com/project/14630/story/671
        my $snapMirrorLabel = "dbbackup";

	#filerb.zmanda.com:/vol/mysql_vol2/

	$opt{"dev"}=~s'/+$'';

	if( $opt{"dev"} =~ /(\S+):\/+\w+\/+(\S+)/ ){
		$Filer = $1;
		$volName = $2;
	}
	else {
		&printAndDie("Invalid device name - $opt{'dev'}");
	}

        # Use NetApp ONTAPI to create snapshot. 

        my $s = NaServer->new($Filer, 1, 1);
        $s->set_admin_user($Admin, $Password);

	if($verbose){
		&printLog("volume name is $volName and snapshotname is $snapName (snapmirror-label is $snapMirrorLabel)\n");
	}
        my $output = $s->invoke("snapshot-create",
                                "volume", $volName,
                                "snapshot", $snapName,
                                "snapmirror-label", $snapMirrorLabel);

        if ($output->results_errno != 0) {
                my $r = $output->results_reason();
                &printAndDie( "Snapshot create failed - $r" );
        }
}

# $opt{"dev"} contains /vol/volName/.snapshot/snapName
sub doMount()
{
	if($verbose){
		&printLog("Mounting the snapshot\n");
	}

	if( !defined $opt{"directory"} ){
		&printAndDie("Please input mount directory using --directory");
	}
	if( !defined $opt{"dev"} ){
		&printAndDie("Please input device to be mounted using --dev");
	}
	if( !defined $opt{"fstype"} ){
		&printAndDie("Please input filesystem type using --fstype");
	}

        #  mount -t nfs filer:/vol/volName/.snapshot/snapName /mountDir
	eval { mkpath( $opt{'directory'} ) };
	if ($@) {
		&printAndDie("Error in creating the path $opt{'directory'} , $@");
	}

        my $command = $MOUNT;
        if( $^O eq "solaris" ){
                $command = "/usr/sbin/$command -F nfs";
        }else{
                $command .= " -t nfs";
        }

	$command .= " $opt{dev} $opt{directory} 2>$LOGGER";
	if($verbose){
		&printLog("Command used for do mount : $command\n");
	}
	my $r = system( "sudo ".$command );	
	if( $r != 0 ){
                &printCommandOutputToSnapshotLog( "ERROR", "Mount failed : $command", $LOGGER );
	}
}


sub doUmount()
{
	if($verbose){
		&printLog("Doing unmount\n");
	}
	if( !defined $opt{"directory"} ){
		&printAndDie("Please specify the directory using --directory");
	}
	my $command = "$UMOUNT $opt{directory} 2>$LOGGER";
	my $r = system( "sudo ".$command );	
	if( $r != 0 ){
                &printCommandOutputToSnapshotLog( "ERROR", "Umount failed with cmd : $command", $LOGGER );
	}
	rmtree( $opt{directory}, 0, 0 );
}


# To remove the snapshot from the filer, we need to supply the snapshot name
# and the volume name also.
# $_[0] is opt{"dev"} 
sub doRemoveSnapshot()
{
	if($verbose){
		&printLog("Removing snapshot\n");
	}
	if( !defined $opt{"dev"} ){
		&printAndDie( "Please input --dev" );
	}
 
        #      opt{"dev"}     ===  Filer:/vol/volName/.snapshot/snapName

        my $Filer;
        my $volName;        
        my $snapName;

	#filerb.zmanda.com:/vol/mysql_vol2//.snapshot/zrmdAvN11TsSk
        if ( $opt{"dev"} =~ /^(\S+):\/+\w+\/+(\S+)\/+\.snapshot\/+(\S+)\/*$/ ) {
                $Filer    = $1;
                $volName  = $2;
                $snapName = $3;
        }

	$Filer =~ s'/+$'';
	$volName =~ s'/+$'';
	$snapName =~ s'/+$'';
        # Use NetApp ONTAPI to delete snapshot. 

        my $s = NaServer->new($Filer, 1, 1);
        $s->set_admin_user($Admin, $Password);

	if($verbose){
		&printLog("going for snapshot delete $volName and $snapName \n");
	}

        my $output = $s->invoke("snapshot-delete",
                                "volume", $volName,
                                "snapshot", $snapName);

        if ($output->results_errno != 0) {
                my $r = $output->results_reason();
                &printAndDie( "Snapshot delete failed - $r" );
        }
}
&printLog("Snapshot plugin started\n");
&initSnapshotPlugin( "netapp-user", "netapp-password" );
&setUpConfParams();
&printLog("Snapshot plugin action : $action \n");

if( $action eq "get-vm-device-details" ){
	&doGetSnapshotdeviceDetails();
}elsif( $action eq "create-snapshot" ){
	&doCreateSnapshot();
}elsif( $action eq "mount" ){
	&doMount();
}elsif( $action eq "umount" ){
	&doUmount();
}elsif( $action eq "remove-snapshot" ){
	&doRemoveSnapshot();
}
&printLog("Snapshot Plugin clean exit\n\n");
exit( 0 );

