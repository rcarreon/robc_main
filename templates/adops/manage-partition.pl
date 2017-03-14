#!/usr/bin/perl -w
use strict;
use DBI;
use DBD::mysql;
use MIME::Base64;

my $datadir = "/sql/data/mysql";
my ($year,$month,$day);
my ($db, $result, $db2, $result2, @row);
my ($droppart, $addpart, $adddate);
my $mail_content = "";

# Define connections to the relevant database systems
my %conn = (
    adops => {
        dbhost => "<%= host_partition_man %>",
        dbname => "adops2_0_production",
        dbuser => "<%= user_partition_man %>",
        dbpass => "<%= pw_partition_man %>",       # Encrypted
    },
    adops_reporting => {
        dbhost => "<%= host_partition_man %>",
        dbname => "adops2_0_production",
        dbuser => "<%= user_partition_man %>",
        dbpass => "<%= pw_partition_man %>",       # Encrypted
    },
);

my %data = (
    proportions_monthy  => {
        db              => "adops2_0_production",
        table           => "payout_proportions",
        func            => "TO_DAYS",
        },
    proportions_daily   => {
        db              => "adops2_0_production",
        table           => "payout_proportions_daily",
        func            => "TO_DAYS",
        },
    reports => {
        db              => "adops2_0_production",
        table           => "reports",
        func            => "",
        },
);


if ($#ARGV < 0) {
    print "A date is necesary\n";
    exit 1;
}

if (validdate($ARGV[0]) == 0) {
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
    my $subject = "[partitions] Ad Platform for $ARGV[0]";
    # my $logrcpt = "dba\@evolvemediallc.com";
    my $logrcpt = "sebastien.dejean\@evolvemediallc.com";

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
    my $sentence = "INSERT INTO db_system.partition (dbname, `table`, `partition`, status, param, extra) VALUES (?, ?, ?, ?, ?, ?)";
    my $result3 = $db3->prepare($sentence);

    if (defined($result3)) {
        $result3->execute($database, $table, $partition, $status, $ARGV[0], $text) or do {
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
    if ($_[0] !~ /(\d{4})-(\d\d)-(\d\d)/) {
        print "Wrong date format: '$ARGV[0]'\n";
        print "Correct date format: 'yyyy-mm-dd'\n\n";
        return 0;
    }
    $year = substr $_[0],0,4;
    $month = substr $_[0],5,2;
    $day = substr $_[0],8,2;

    if (($month < 1) || ($month > 12)) {
        print "Invalid month\n\n";
        return 0;
    }
    # 2 digit year in partitions
    $addpart = "p".substr($year,2).$month;
    # 4 digit year in partitions
    $addpart = "p".$year.$month;

    if ($month == 12) {
        $year++;
        $month = '01';
    } else {
        $month++;
    }

    $month   = sprintf("%02s", $month);
    $adddate = $year."-".$month."-01 00:00:00";

    print $addpart."\n";
    print $adddate."\n";

    return 1;
}

# Iterate $conn hash
foreach my $key ( keys %conn ) {
    # Iterate $data hash
    foreach my $key_data ( keys %data ) {
        if ( ($conn{$key}{dbname}) eq ($data{$key_data}{db})  ) {

            $db = &open_db_conn($data{$key_data}{db}, $conn{$key}{dbhost}, $conn{$key}{dbuser}, decode_base64($conn{$key}{dbpass}));
            $result = $db->prepare("SHOW CREATE TABLE ".$data{$key_data}{db}.".".$data{$key_data}{table});
            $result->execute();

            while (@row = $result->fetchrow_array()) {

                print "\n".$conn{$key}{dbhost}.".".$data{$key_data}{db}.".".$data{$key_data}{table}.":\n";
                $mail_content = $mail_content."\n".$conn{$key}{dbhost}.".".$data{$key_data}{db}.".".$data{$key_data}{table}.":\n";

                print "Preparting to add partition: ".$addpart."\n";
                if (index($row[1],$addpart) == -1) {

                    # Check if there is a defined partitioning function and if so, use it
                    my $partition_value = "'$adddate'";
                    if ( length $data{$key_data}{func} ) {
                        my $partition_value = $data{$key_data}{func} . "('$adddate')";
                    }

                    print "\t*ADDED: Partition ".$addpart." LESS THAN ($partition_value) to ".$data{$key_data}{db}.".".$data{$key_data}{table}."\n";
                    $mail_content = $mail_content."\t*ADDED: Partition ".$addpart." LESS THAN ($partition_value) to ".$data{$key_data}{db}.".".$data{$key_data}{table}."\n";
                    $db2 = &open_db_conn($data{$key_data}{db}, $conn{$key}{dbhost}, $conn{$key}{dbuser}, decode_base64($conn{$key}{dbpass}));
                    my $sql_drop = "ALTER TABLE ".$data{$key_data}{db}.".".$data{$key_data}{table}." DROP PARTITION pMAX;";
                    $result2 = $db2->prepare($sql_drop);
                    $result2->execute();
                    &close_db_conn( $result2, $db2 );
                    
                    $db2 = &open_db_conn($data{$key_data}{db}, $conn{$key}{dbhost}, $conn{$key}{dbuser}, decode_base64($conn{$key}{dbpass}));
                    my $sql_add = "ALTER TABLE ".$data{$key_data}{db}.".".$data{$key_data}{table}." ADD PARTITION (PARTITION ".$addpart." VALUES LESS THAN ($partition_value) ENGINE = InnoDB, PARTITION pMAX VALUES LESS THAN MAXVALUE ENGINE = InnoDB);";
                    $result2 = $db2->prepare($sql_add);
                    $result2->execute();
                    &close_db_conn( $result2, $db2 );
                    &insert_log($data{$key_data}{db},$data{$key_data}{table},$addpart,'add',("Partition ".$addpart." LESS THAN ($partition_value) added to ".$data{$key_data}{db}.".".$data{$key_data}{table}), $conn{$key}{dbhost}, $conn{$key}{dbuser}, decode_base64($conn{$key}{dbpass}));
                } else {
                    print "\t*NOT ADDED: Partition ".$addpart." already exist for ".$data{$key_data}{db}.".".$data{$key_data}{table}."\n";
                    $mail_content = $mail_content."\t*NOT ADDED: Partition ".$addpart." already exist for ".$data{$key_data}{db}.".".$data{$key_data}{table}."\n";
                    &insert_log($data{$key_data}{db},$data{$key_data}{table},$addpart,'notadded',("Partition ".$addpart." already exist for ".$data{$key_data}{db}.".".$data{$key_data}{table}), $conn{$key}{dbhost}, $conn{$key}{dbuser}, decode_base64($conn{$key}{dbpass}));
                }

            }
        }
    }
}

&send_mail();
