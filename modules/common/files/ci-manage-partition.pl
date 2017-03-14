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

my %conn = (
    dw => {
        dbhost => "sql1v-56-dw.ci.prd.lax.gnmedia.net",
        dbname => "warehouse",
        dbuser => "dba",
        dbpass => "Z29yaWxsYW1hc3Rlcjc4OQ==",
    },
    audit => {
        dbhost => "sql1v-56-audit.ci.prd.lax.gnmedia.net",
        dbname => "audit",
        dbuser => "dba",
        dbpass => "Z29yaWxsYW1hc3Rlcjc4OQ==",
    },
    dw_stg => {
        dbhost => "sql1v-56-dw.ci.stg.lax.gnmedia.net",
        dbname => "warehouse",
        dbuser => "dba",
        dbpass => "Z29yaWxsYW1hc3Rlcjc4OQ==",
    },
    audit_stg => {
        dbhost => "sql1v-56-audit.ci.stg.lax.gnmedia.net",
        dbname => "audit",
        dbuser => "dba",
        dbpass => "Z29yaWxsYW1hc3Rlcjc4OQ==",
    },
);

my %data = (
    social                => {
        db              => "warehouse",
        table           => "history_socials",
        },
    timer                 => {
        db              => "warehouse",
        table           => "history_timers",
        },
    stats_accounts        => {
        db              => "warehouse",
        table           => "stats_accounts",
        },
    stats_landing_page    => {
        db              => "warehouse",
        table           => "stats_landing_page",
        },
    stats_page            => {
        db              => "warehouse",
        table           => "stats_page",
        },
    stats_widget          => {
        db              => "warehouse",
        table           => "stats_widget",
        },
    stats_widgets_account => {
        db              => "warehouse",
        table           => "stats_widgets_account",
        },
    logs                  => {
        db              => "audit",
        table           => "logs",
        },
    general_url           => {
        db              => "audit",
        table           => "general_url",
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
    my $subject = "CI [partitions] DW-AUDIT for $ARGV[0]";
    my $logrcpt = "dba\@evolvemediallc.com";

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
    my $sentence = "INSERT INTO db_system.partition (dbname, `table`, `partition`, status, param, extra) VALUES ('".$database."','".$table."','".$partition."','".$status."','".$ARGV[0]."','".$text."')";
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

    $addpart = "p".substr($year,2).$month;

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

                $mail_content = $mail_content."\n".$conn{$key}{dbhost}.".".$data{$key_data}{db}.".".$data{$key_data}{table}.":\n";

                if (index($row[1],$addpart) == -1) {
                    $mail_content = $mail_content."\t*ADDED: Partition ".$addpart." LESS THAN ('".$adddate."') to ".$data{$key_data}{db}.".".$data{$key_data}{table}."\n";
                    $db2 = &open_db_conn($data{$key_data}{db}, $conn{$key}{dbhost}, $conn{$key}{dbuser}, decode_base64($conn{$key}{dbpass}));
                    $result2 = $db2->prepare("ALTER TABLE ".$data{$key_data}{db}.".".$data{$key_data}{table}." DROP PARTITION pMAX;");
                    $result2->execute();
                    &close_db_conn( $result2, $db2 );

                    $db2 = &open_db_conn($data{$key_data}{db}, $conn{$key}{dbhost}, $conn{$key}{dbuser}, decode_base64($conn{$key}{dbpass}));
                    $result2 = $db2->prepare("ALTER TABLE ".$data{$key_data}{db}.".".$data{$key_data}{table}." ADD PARTITION (PARTITION ".$addpart." VALUES LESS THAN (UNIX_TIMESTAMP('".$adddate."')) ENGINE = InnoDB, PARTITION pMAX VALUES LESS THAN MAXVALUE ENGINE = InnoDB);");
                    $result2->execute();
                    &close_db_conn( $result2, $db2 );
                    &insert_log($data{$key_data}{db},$data{$key_data}{table},$addpart,'add',("Partition ".$addpart." LESS THAN (''".$adddate."'') added to ".$data{$key_data}{db}.".".$data{$key_data}{table}), $conn{$key}{dbhost}, $conn{$key}{dbuser}, decode_base64($conn{$key}{dbpass}));
                } else {
                    $mail_content = $mail_content."\t*NOT ADDED: Partition ".$addpart." already exist for ".$data{$key_data}{db}.".".$data{$key_data}{table}."\n";
                    &insert_log($data{$key_data}{db},$data{$key_data}{table},$addpart,'notadded',("Partition ".$addpart." already exist for ".$data{$key_data}{db}.".".$data{$key_data}{table}), $conn{$key}{dbhost}, $conn{$key}{dbuser}, decode_base64($conn{$key}{dbpass}));
                }

            }
        }
    }
}

&send_mail();
