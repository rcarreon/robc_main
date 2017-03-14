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

my ($db, $result, @tbl);
my $mail_content = "";
my $message = "";
my $query = "";


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
    my $subject = sprintf("%s: %s-INFO [Analytics Benchmark Report]", uc($hostname_detailed[2]), uc($hostname_detailed[1]));
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

sub validdate {
    my $opdate;

    eval {
        $opdate = Time::Piece->strptime($date, "%Y-%m-%d");
    };

    if ( $@ ) {
        print "Wrong date format: '$date'\n";
        print "Correct date format: 'yyyy-mm-dd'\n\n";
        return 0;
    }

    return 1;
}

$query="CALL ea_og_sp_calculate_product_benchmark_report('".$date."')";
$db = &open_db_conn("analytics", $hostname, "dbops", decode_base64("ZXZvbHZlZ2VuaXVzOTg3"));
$result = $db->prepare($query);
$result->execute();

$mail_content = "Rows added for the following date ranges:\n\n";

while (@tbl = $result->fetchrow_array()) {
    $message = "\t* From ".$tbl[0]." to ".$tbl[1]."\n";
    $mail_content = $mail_content.$message;
}

&send_mail();
