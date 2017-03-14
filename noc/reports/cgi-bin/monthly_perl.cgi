#!/usr/bin/perl -w
#
use strict; 
use base 'Exporter';
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
no warnings;
my $RTSERVER = 'https://rt.gorillanation.com/';
our @EXPORT = qw< $RTUSER $RTSERVER $RTPASSWD >;
#hashed password md5
#my $RTPASSWD = '3502c375cb456df70c442cb2f369a854';
my $output = "/app/shared/http/reports/cgi-bin/output";

my ($q, $vert, $sdate, $edate, $line, $ticket_no, $header,$rcause, $creator, $search_status,$gq);
$q = CGI->new();
$gq = $q->param('gquery');
$vert = $q->param('vertq');
$sdate = $q->param('sdate');
$edate = $q->param('edate');
$rcause = $q->param('rcq');
$creator = $q->param('crea');
chomp($vert, $sdate, $edate);
print $q->header();
#Here is the query to get all the tickets.

#sub  grand_query_perdate{
#open OUT, "+< $output" or die $!;
#executing a command with perl, particulary  the Grand query 
#my $Grand_query_perdate=`/app/shared/http/reports/cgi-bin/rt  ls -o -Created -t ticket " Queue = 'Q_NOC' AND  (  Status = 'open' OR Status = 'new' OR Status = 'stalled' OR Status = 'resolved' ) AND Created > '$sdate 00:00:00' AND Created <= '$edate 23:59:59' AND Subject NOT LIKE 'ZRM' AND Subject NOT LIKE 'Fwd:' AND Subject NOT LIKE 'Re:' "`;
#print OUT $header;
#print OUT  $Grand_query_perdate;
#close OUT;
#}
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
	$search_status = `/app/shared/http/reports/cgi-bin/rt show ticket/$ticket -f status | grep -m 1 -i status`;
        my $lmth= "       
        <strong><a style=text-decoration:none href=https://rt.gorillanation.com/Ticket/Display.html?id=$ticket>&nbsp $line &nbsp&nbsp</a>&nbsp&nbsp$search_status</strong><br>" ;
        print $lmth;
}
print "</div>";
close VER;
}
#creating a subrutine to for the Vertical Query
sub query_vertical{
open VER, "> $output" or die $!;

######my $Query_created=`/var/lib/rt_script/rt show ticket/`
my $Query_vertical=`/app/shared/http/reports/cgi-bin/rt ls -o -Created -t ticket " Queue = 'Q_NOC' AND  (  Status = 'open' OR Status = 'new' OR Status = 'stalled' OR Status = 'resolved' ) AND Created > '$sdate 00:00:00' AND Created <= '$edate 23:59:59' AND Subject NOT LIKE 'ZRM' AND Subject NOT LIKE 'Fwd:' AND Subject NOT LIKE 'Re:'  AND 'CF.{Vertical}' = '$vert' "`;
#Printing results of the query to a file 
print VER $Query_vertical;
close VER;
#open the same file for read  and output
$header = "<head>
	 <link type=text/css rel=stylesheet href=../css/demo_page.css />
	</head>
	<body id=dt_example>
	<div id=container>
	<img src=../images/banner.jpg>
	<h3 align=center> Tickets Created from $sdate to $edate for $vert </h3>
	";
	print $header;
	&print_html;
}
sub query_rcause{
open VER, "> $output" or die $!;
my $Query_rcause=`/app/shared/http/reports/cgi-bin/rt ls -o -Created -t ticket " Queue = 'Q_NOC' AND  (  Status = 'open' OR Status = 'new' OR Status = 'stalled' OR Status = 'resolved' ) AND Created > '$sdate 00:00:00' AND Created <= '$edate 23:59:59' AND Subject NOT LIKE 'ZRM' AND Subject NOT LIKE 'Fwd:' AND Subject NOT LIKE 'Re:'  AND 'CF.{Root Cause}' = '$rcause' "`;
print VER $Query_rcause;
close VER;
	$header ="<head>
         <link type=text/css rel=stylesheet href=../css/demo_page.css />
        </head>
        <body id=dt_example>
        <div id=container>
        <img src=../images/banner.jpg>
        <h3 align=center> Tickets Created from $sdate to $edate for $rcause </h3>
        ";
	print $header;
	&print_html;
}
sub query_creator{
open VER, "> $output" or die $!;
my $Query_creator=`/app/shared/http/reports/cgi-bin/rt ls -o -Created -t ticket " Queue = 'Q_NOC' AND  (  Status = 'open' OR Status = 'new' OR Status = 'stalled' OR Status = 'resolved' ) AND Created > '$sdate 00:00:00' AND Created <= '$edate 23:59:59' AND Subject NOT LIKE 'ZRM' AND Subject NOT LIKE 'Fwd:' AND Subject NOT LIKE 'Re:'  AND Creator = '$creator' "`;
print VER $Query_creator;
close VER;
        $header ="<head>
         <link type=text/css rel=stylesheet href=../css/demo_page.css />
        </head>
        <body id=dt_example>
        <div id=container>
        <img src=../images/banner.jpg>
        <h3 align=center> Tickets Created from $sdate to $edate for $creator </h3>
        ";
        print $header;
        &print_html;
}
sub  grand_query_perdate{
open VER, ">  $output" or die $!;
#executing a command with perl, particulary  the Grand query 
my $Grand_query_perdate=`/app/shared/http/reports/cgi-bin/rt  ls -o -Created -t ticket " Queue = 'Q_NOC' AND  (  Status = 'open' OR Status = 'new' OR Status = 'stalled' OR Status = 'resolved' ) AND Created > '$sdate 00:00:00' AND Created <= '$edate 23:59:59' AND Subject NOT LIKE 'ZRM' AND Subject NOT LIKE 'Fwd:' AND Subject NOT LIKE 'Re:' "`;
#
print VER $Grand_query_perdate;
close VER;
	$header ="<head>
         <link type=text/css rel=stylesheet href=../css/demo_page.css />
        </head>
        <body id=dt_example>
        <div id=container>
        <img src=../images/banner.jpg>
        <h3 align=center> Tickets Created from $sdate to $edate </h3>
        ";
	print $header;
	&print_html;
}


if ($gq){
&grand_query_perdate;
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
