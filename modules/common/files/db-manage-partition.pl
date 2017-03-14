#!/usr/bin/perl -w
use strict;
use DBI;
use DBD::mysql;
use MIME::Base64;
use Time::Piece;
use Time::Seconds;

my $date=shift;
my $hostname=shift;
my $cc=shift;
my $weekly=shift;
my $datadir = "/sql/data/mysql";
my ($year,$month,$day);
my ($db0, $result0, $db, $result, $db2, $result2, @row, @tbl);
my ($droppart, $addpart, $adddate);
my $mail_content = "";
my $message = "";


if ( ("$date" eq "") || ("$hostname" eq "") ) {
    print "A date and hostname are necesary\n";
    exit 1;
}

if (validdate($date) == 0) {
    exit 1;
}

sub open_db_conn() {
    my $db = shift;
    my $host = shift;
    my $user = shift;
    my $passw = shift;
    my $dsn = "dbi:mysql:$db:$host:3306";
    return DBI->connect($dsn, $user, $passw) or die "Unable to connect: $DBI::errstr\n";
}
sub close_db_conn() {
    my $result = shift;
    my $close = shift;

    $result->finish;
    $close->disconnect;
}

sub send_mail() {
    my @hostname_detailed = split (/\./, $hostname);
    my $subject = sprintf("%s: %s-INFO [Manage Partition]", uc($hostname_detailed[2]), uc($hostname_detailed[1]));
    my $logrcpt = "dba\@evolvemediallc.com";

    if ( $cc ne "" ) {
        $logrcpt = $logrcpt.",".$cc;
    }
    open (MAIL, "|mailx -s \"$subject\" $logrcpt");
    print MAIL $mail_content;
    print MAIL "\n\nScript.";
    close MAIL;

    return 0;
}

sub insert_log() {
    my $database = shift;
    my $table = shift;
    my $partition = shift;
    my $status = shift;
    my $text = shift;
    my $log_dbhost = shift;
    my $log_dbuser = shift;
    my $log_dbpass = shift;

    my $db3 = &open_db_conn("db_system", $log_dbhost, $log_dbuser, $log_dbpass);
    my $sentence = "INSERT INTO db_system.partition (dbname, `table`, `partition`, status, param, extra) VALUES ('".$database."','".$table."','".$partition."','".$status."','".$date."','".$text."')";
    my $result3 = $db3->prepare($sentence);

    if (defined($result3)) {
        $result3->execute() or do {
            &close_db_conn( $result3, $db3 );
            return 0;
        };
        &close_db_conn( $result3, $db3 );
        return 1;
    } else {
        &close_db_conn( $result3, $db3 );
        return 0;
    }
}

sub validdate {
    my $opdate;

    eval{
        $opdate = Time::Piece->strptime($date, "%Y-%m-%d");
    };

    if ( $@ )
    {
        print "Wrong date format: '$date'\n";
        print "Correct date format: 'yyyy-mm-dd'\n\n";
        return 0;
    }

    if ($weekly eq "")
    {
        $addpart = $opdate->strftime("p%y%m");
        $opdate += ONE_MONTH;
        $adddate = $opdate->strftime("%Y-%m-01 00:00:00");
    }
    else
    {
        if ($opdate->day_of_week != 1)
        {
            my $diff = $opdate->day_of_week - 1;
            $opdate -= (ONE_DAY * $diff);
        }

        $opdate += ONE_WEEK;
        $addpart = $opdate->strftime("p%Y%U");
        $opdate += ONE_WEEK;
        $adddate = $opdate->strftime("%Y-%m-%d 00:00:00");

    }

    return 1;
}

$db0 = &open_db_conn("information_schema", $hostname, "part_manager", decode_base64("SmI1aDVMcGw="));
$result0 = $db0->prepare("SELECT DISTINCT TABLE_SCHEMA, TABLE_NAME FROM INFORMATION_SCHEMA.PARTITIONS WHERE PARTITION_NAME IS NOT NULL");
$result0->execute();

while (@tbl = $result0->fetchrow_array()) {
    $db = &open_db_conn($tbl[0], $hostname, "part_manager", decode_base64("SmI1aDVMcGw="));
    $result = $db->prepare("SHOW CREATE TABLE ".$tbl[0].".".$tbl[1]);
    $result->execute();

    while (@row = $result->fetchrow_array()) {
        $message = "\n".$tbl[0].".".$tbl[1].":\n";
        $mail_content = $mail_content.$message;

        if (index($row[1],$addpart) == -1) {
            $message = "\t*ADDED: Partition ".$addpart." LESS THAN ('".$adddate."') to ".$tbl[0].".".$tbl[1]."\n";
            $mail_content = $mail_content.$message;

            $db2 = &open_db_conn($tbl[0], $hostname, "part_manager", decode_base64("SmI1aDVMcGw="));
            $result2 = $db2->prepare("ALTER TABLE ".$tbl[0].".".$tbl[1]." DROP PARTITION pMAX;");
            $result2->execute();
            &close_db_conn( $result2, $db2 );

            $db2 = &open_db_conn($tbl[0], $hostname, "part_manager", decode_base64("SmI1aDVMcGw="));
            $result2 = $db2->prepare("ALTER TABLE ".$tbl[0].".".$tbl[1]." ADD PARTITION (PARTITION ".$addpart." VALUES LESS THAN (UNIX_TIMESTAMP('".$adddate."')), PARTITION pMAX VALUES LESS THAN MAXVALUE);");
            $result2->execute();
            &close_db_conn( $result2, $db2 );
            &insert_log($tbl[0], $tbl[1], $addpart, 'add', ("Partition ".$addpart." LESS THAN (''".$adddate."'') added to ".$tbl[0].".".$tbl[1]), $hostname, "part_manager", decode_base64("SmI1aDVMcGw="));
        } else {
            $message = "\t*NOT ADDED: Partition ".$addpart." already exist for ".$tbl[0].".".$tbl[1]."\n";
            $mail_content = $mail_content.$message;
            &insert_log($tbl[0], $tbl[1], $addpart, 'notadded', ("Partition ".$addpart." already exist for ".$tbl[0].".".$tbl[1]), $hostname, "part_manager", decode_base64("SmI1aDVMcGw="));
        }

    }
}

&send_mail();
