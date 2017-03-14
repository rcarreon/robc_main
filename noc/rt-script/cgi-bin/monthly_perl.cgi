#!/usr/bin/perl -w
#
use strict; 
use base 'Exporter';
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
no warnings;
our @EXPORT = qw< $RTUSER $RTSERVER $RTPASSWD >;
my $RTUSER = 'rt_svc_user';
#hashed password md5
my $RTPASSWD = '3502c375cb456df70c442cb2f369a854';
my $RTSERVER = 'https://rt.gorillanation.com/';
my $output = "/var/lib/rt_script/cgi/output";
my ($q, $vert, $sdate, $edate, $line, $ticket_no, $header,$rcause, $creator);
$q = CGI->new();
$vert = $q->param('vertq');
$sdate = $q->param('sdate');
$edate = $q->param('edate');
$rcause = $q->param('rcq');
$creator = $q->param('crea');
chomp($vert, $sdate, $edate);
print $q->header();
#Here is the query to get all the tickets.
sub  grand_query_perdate{
open OUT, "+< $output" or die $!;
#executing a command with perl, particulary  the Grand query 
my $Grand_query_perdate=`/var/lib/rt_script/rt ls -o -Created -t ticket " Queue = 'Q_NOC' AND  (  Status = 'open' OR Status = 'new' OR Status = 'stalled' OR Status = 'resolved' ) AND Created > '$sdate 00:00:00' AND Created <= '$edate 23:59:59' AND Subject NOT LIKE 'ZRM' AND Subject NOT LIKE 'Fwd:' AND Subject NOT LIKE 'Re:' "`;
print OUT $header;
print OUT  $Grand_query_perdate;
close OUT;
}
sub print_html{
#this the the loop to read line by line the file generated and put it on the html document
#        ## this is to get the Creator and the creation date  and the status, but needs improvement bc takes to long to get results
#                #my $Created=`/var/lib/rt_script/rt show ticket/$ticket| egrep 'Creator|Created'`;
#                        #my $Status=`/var/lib/rt_script/rt show ticket/$ticket| egrep 'Status'`;
#
open VER, "< $output" or die $!;
        while($line = readline(VER)){
        $line=~ m/(\d+)/;
        my $ticket = $1;
        my $lmth= "
        <html>
        <head>
        <title> Search results </title>
        </head>
        <div style=margin:0 auto>
        <strong><a style=text-decoration:none href=https://rt.gorillanation.com/Ticket/Display.html?id=$ticket>&nbsp $line &nbsp&nbsp</a>&nbsp&nbsp</strong><br>
        </div>
        </html>";
        print $lmth;
}

}
#creating a subrutine to for the Vertical Query
sub query_vertical{
open VER, "> $output" or die $!;

######my $Query_created=`/var/lib/rt_script/rt show ticket/`
my $Query_vertical=`/var/lib/rt_script/rt ls -o -Created -t ticket " Queue = 'Q_NOC' AND  (  Status = 'open' OR Status = 'new' OR Status = 'stalled' OR Status = 'resolved' ) AND Created > '$sdate 00:00:00' AND Created <= '$edate 23:59:59' AND Subject NOT LIKE 'ZRM' AND Subject NOT LIKE 'Fwd:' AND Subject NOT LIKE 'Re:'  AND 'CF.{Vertical}' = '$vert' "`;
#Printing results of the query to a file 
print VER $Query_vertical;
close VER;
#open the same file for read  and output
$header = "<h2 align=center> Tickets Created from $sdate to $edate for $vert </h2>";
print $header;
	&print_html;
}
close VER;
sub query_rcause{
open VER, "> $output" or die $!;
my $Query_rcause=`/var/lib/rt_script/rt ls -o -Created -t ticket " Queue = 'Q_NOC' AND  (  Status = 'open' OR Status = 'new' OR Status = 'stalled' OR Status = 'resolved' ) AND Created > '$sdate 00:00:00' AND Created <= '$edate 23:59:59' AND Subject NOT LIKE 'ZRM' AND Subject NOT LIKE 'Fwd:' AND Subject NOT LIKE 'Re:'  AND 'CF.{Root Cause}' = '$rcause' "`;
print VER $Query_rcause;
close VER;
	$header = "<h2 align=center> Tickets Created from $sdate to $edate for $rcause </h2>";
	print $header;
	&print_html;
}
sub query_creator{
open VER, "> $output" or die $!;
my $Query_creator=`/var/lib/rt_script/rt ls -o -Created -t ticket " Queue = 'Q_NOC' AND  (  Status = 'open' OR Status = 'new' OR Status = 'stalled' OR Status = 'resolved' ) AND Created > '$sdate 00:00:00' AND Created <= '$edate 23:59:59' AND Subject NOT LIKE 'ZRM' AND Subject NOT LIKE 'Fwd:' AND Subject NOT LIKE 'Re:'  AND Creator = '$creator' "`;
print VER $Query_creator;
close VER;
        $header = "<h2 align=center> Tickets Created by $creator from $sdate to $edate </h2>";
        print $header;
        &print_html;
}

if ($vert){ 
&query_vertical;
}
if ($rcause){
&query_rcause;
}
if ($creator){
&query_creator;
}
