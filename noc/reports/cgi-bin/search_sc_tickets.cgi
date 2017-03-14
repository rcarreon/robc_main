#!/usr/bin/perl -w
#
use strict; 
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use POSIX qw(strftime);
no warnings;
`/bin/sh ../ticket_crawler.sh`;
my $RTSERVER = 'https://rt.gorillanation.com/';
our @EXPORT = qw< $RTUSER $RTSERVER $RTPASSWD >;
#my $date = strftime "%m/%a/%y", localtime;
my $date = strftime "%a %d %Y", localtime;
#$date =~ s/\///g;
my $output = "/app/shared/http/reports/cgi-bin/output";
my $output2 = "/app/shared/http/reports/cgi-bin/sc1";
my $output3 = "/app/shared/http/reports/cgi-bin/ticket_craw";
my ($q,$sdate, $edate, $line,  $header, $search_status,$sc,$Query_sc,$last, $line2);

$q = CGI->new();
$sc= $q->param('stat');
$sdate = $q->param('sdate');
$edate = $q->param('edate');
chomp($sdate, $edate);
print $q->header();
my $lmth3="<div id=container><h2><a href=http://dev.nocreports.gnmedia.net/ticket_thurdays.php>Go to Thursdays reviews</a></h2></div>";

##Subrutine to get the RT  queries and with subs mond and thur print them to html.
sub print_html{
`sed -i '/matching/d' $output`;
open VER, "< $output" or die $!;
        while($line = readline(VER)){
        	$line=~ m/(\d+)/;
	        my $ticket = $1;
		my $last = `/app/shared/http/reports/cgi-bin/rt show ticket/$ticket/history -f content | grep -m1 "Last Name:" | cut -d":" -f2 | sed 's/ //g'`;
		chomp($last);
		my $release =`/app/shared/http/reports/cgi-bin/rt show ticket/$ticket/history -f content| grep -m1 "Date"| cut -d ":" -f2 | sed 's/ //g'`;
		my $search_status = `/app/shared/http/reports/cgi-bin/rt show ticket/$ticket -f status | grep -m 1 -i status`;
		my $Query_sc1= ` /app/shared/http/reports/cgi-bin/rt show ticket/$ticket | grep '^CF' | egrep -vi 'done|N\/A'| sed 's/CF\-SC\_//'| sed '/StatusChangeMatrix/d'`;
$Query_sc1=~ s/\://g;
open VERT, "> $output2" or die $!;
print VERT $Query_sc1;
close VERT;
##testing if the file is empty or not; al the results are taken from RT CF's
		if (!(-s $output2)){
			my $empty= "This ticket should be resolved";
			my $lmth= "       
                       <br><strong>Ticket&nbsp<a style=text-decoration:none href=https://rt.gorillanation.com/Ticket/Display.html?id=$ticket>&nbsp $line &nbsp&nbsp</a>$search_status<br>Release Date: $release</strong>";
                        print  $lmth;
                       my $lmth2 = "<br><p>$empty </p><br>";
                       print $lmth2
		}else {
	        	my $lmth= "       
	        	<br><strong>Ticket&nbsp<a style=text-decoration:none href=https://rt.gorillanation.com/Ticket/Display.html?id=$ticket>&nbsp $line &nbsp&nbsp</a>$search_status<br>Release Date: $release</strong>";
			print  $lmth;
			if ($date =~ m/(Mon|Tue|Wed)/){
				open VERT, "< $output2" or die $!;
				        while(my $line2 = readline(VERT)){
	                			chomp($line2);
        	        			my $match=`cat ticket_craw| grep $line2| grep $last`;
 				                my $lmth2 = "<br><a href=$match>$line2</a>";
				                print $lmth2;
        				}
		        	close VERT;
			}elsif($date =~ m/(Thu|Fri|Sat|Sun)/){
                                open VERT, "< $output2" or die $!;
                                        while (my $line2 = readline(VERT)){
                                                my $lmth2="
                                                <p>$line2</p>";
                                                print $lmth2;
                                        }
                                close VERT;
                        }
		}
	}
	print "</div>";
	close VER;
}
###creating a subrutine to for the Vertical Query
sub query_sc{
open VER, "> $output" or die $!;
	my $Query_sc= `/app/shared/http/reports/cgi-bin/rt ls -o  -Created -t ticket " Queue = 'Q_StatusChange' AND  (  Status = 'open' OR Status = 'new' OR Status = 'stalled' ) AND Created > '$sdate 00:00:00' and Created <= '$edate 23:59:59' AND Subject NOT LIKE 'Re:' and subject not like 'Fw:' "`;
	chomp ($Query_sc);
	print VER $Query_sc."\n";
close VER;
$header ="<head>
         <link type=text/css rel=stylesheet href=../css/demo_page.css />
        </head>
        <body id=dt_example>
        <div id=container>
        <img src=../images/banner.jpg>
	<strong><p>Ticket at least an area without response</p><p>$date</p></strong>";
        print $header;
        &print_html;
}
if ($sc){
	if($date =~ m/(Thu|Fri|Sat|Sun)/){
	              	&query_sc;	
                        print $lmth3;
                        close VERT;
	} else {
			&query_sc;
		}
}
##cleaning up 
`rm -f /app/shared/http/reports/cgi-bin/output`;
`rm -f /app/shared/http/reports/cgi-bin/sc1`;
#`rm -f /app/shared/http/reports/cgi-bin/output2`;
