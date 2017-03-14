#!/usr/bin/perl -w
use strict;

use DBI;
use DBD::mysql;

my $datadir = "/sql/data/mysql";
my ($year,$month,$day,$minyear,$minmonth,$minday,$current_min,$current_param);
my ($db, $result, @row, $email_content);

my %log = (
    dbhost => "localhost",
    dbname => "archive",
    dbuser => "local_archive_w",
    dbpass => "1OrIlLH4",
);

my %data = (
    page               => {
        db              => "warehouse",
        table           => "history_pages",
        },
    social	       => {
        db              => "warehouse",
        table           => "history_socials",
	},
    timer  	       => {
        db              => "warehouse",
        table           => "history_timers",
	},
    stats_widget       => {
        db              => "warehouse",
        table           => "stats_widget",
        },
    stats_landing_page => {
        db              => "warehouse",
        table           => "stats_landing_page",
        },
    stats_accounts     => {
        db              => "warehouse",
        table           => "stats_accounts",
        },    
    stats_widgets_account => {
	db		=> "warehouse",
	table		=> "stats_widgets_account",
	},
    logs	       => {
        db              => "audit",
        table           => "logs",
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
    my $subject = "[ERROR] CI-Missing data for $ARGV[0]";
    my $logrcpt = "dba\@evolvemediallc.com";

    open (MAIL, "|mailx -s \"$subject\" $logrcpt");
    print MAIL $email_content;
    print MAIL "\nScript.";
    close MAIL;

    return 0;
}

sub validdate {
    if ($_[0] !~ /(\d{4})-(\d\d)-(\d\d)/) {
        print "Wrong date format: '$ARGV[0]'\n";
        print "Correct date format: 'yyyy-mm-dd'\n\n";
        return 0;
    }
    $year = substr $_[0],0,4;
    $minyear = $year;
    if ( ($year < 2010) || ($year > 2015) ) {
        print "Invalid year. Only years from 2010 to 2015 are allowed\n\n";
        return 0;
    }
    $month = substr $_[0],5,2;
    $minmonth = $month;
    if (($month < 1) || ($month > 12)) {
        print "Invalid month\n\n";
        return 0;
    }
    $day = substr $_[0],8,2;
    $minday = $day;
    if ( ($day < 1)  ||
         ($day > 31) ||
        (($day > 30) && (($month == 4) || ($month == 6) || ($month == 9) || ($month == 11))) ||
        (($day > 28) && ($month == 2) && ($year != 2012)) ||
        (($day > 29) && ($month == 2) && ($year == 2012)) ) {
        print "Invalid day\n\n";
        return 0;
    }
    $current_min = "$minyear$minmonth$minday";
    $current_param = "$year$month$day";
    return 1;
}

sub get_total_dest() {
    my $key_data_db = shift;
    my $key_data_table = shift;
    my $total = 0;
    my $key_data_query = "SELECT COUNT(1) AS total FROM ".$key_data_db.".".$key_data_table."_".$minyear.$minmonth."
    WHERE created >= UNIX_TIMESTAMP('".$ARGV[0]." 00:00:00') AND created <= UNIX_TIMESTAMP('".$ARGV[0]." 23:59:59')";
    
    $db = &open_db_conn($log{dbname}, $log{dbhost}, $log{dbuser}, $log{dbpass});
    $result = $db->prepare($key_data_query);

    if (defined($result)) {
        $result->execute() or do {
            return 0;
            die "\n[ERROR]:Could not execute the query to ".$key_data_db.".".$key_data_table."_".$minyear.$minmonth."\n";
        };
        while (@row = $result->fetchrow_array()){
            $total = $row[0];
        }
        &close_db_conn($result, $db);
        return $total;
    } else {
        return 0;
        die "\n[ERROR]:Could not execute the query to ".$key_data_db.".".$key_data_table."_".$minyear.$minmonth."\n";
    }
}

sub get_total_source() {
    my $key_data_db = shift;
    my $key_data_table = shift;
    my $total = 0;
    my $key_data_query = "SELECT rows FROM archive.log WHERE dbname = '".$key_data_db."' AND to_table = '".$key_data_table."_".$minyear.$minmonth."' AND from_date = '".$ARGV[0]."'";
    
    $db = &open_db_conn($log{dbname}, $log{dbhost}, $log{dbuser}, $log{dbpass});
    $result = $db->prepare($key_data_query);

    if (defined($result)) {
        $result->execute() or do {
            return 0;
            die "\n[ERROR]:Could not execute the query to archive.log\n";
        };
        while (@row = $result->fetchrow_array()){
            $total = $row[0];
        }
        &close_db_conn($result, $db);
        return $total;
    } else {
        return 0;
        die "\n[ERROR]:Could not execute the query to archive.log\n";
    }
}

$email_content = "";
foreach my $key_data ( keys %data ) {
    print "Table: ".$data{$key_data}{db}.".".$data{$key_data}{table}."\n";
    my $total_source = &get_total_source($data{$key_data}{db}, $data{$key_data}{table});
    my $total_dest = &get_total_dest($data{$key_data}{db}, $data{$key_data}{table});

    if ($total_source > 0) {
        if ($total_source ne $total_dest) {
            print "\t[ERROR] Source: ".$total_source." VS Archived: ".$total_dest."\n";
            print "\tFor: ".$data{$key_data}{db}.".".$data{$key_data}{table}."_".$minyear.$minmonth."\n\tDate: '".$ARGV[0]."':\n\tMust have ".$total_source." and there are ".$total_dest." total rows.\n";
            $email_content = $email_content."\n\tIn: ".$data{$key_data}{db}.".".$data{$key_data}{table}."_".$minyear.$minmonth."\n\tFor: '".$ARGV[0]."'\n\tMust be ".$total_source." and there are ".$total_dest." total rows.\n";
        } else {
            print "\t[DONE] Source: ".$total_source." VS Archived: ".$total_dest."\n";
        }
    }
}

if ($email_content ne "") {
    $email_content = "Missing Data:\n".$email_content;
    &send_mail();
}
