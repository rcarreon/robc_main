#!/usr/bin/perl -w
#
use strict; 
use base 'Exporter';
use CGI qw(:standard);
no warnings;
our @EXPORT = qw< $RTUSER $RTSERVER $RTPASSWD >;
my $RTUSER = 'rt_svc_user';
#my $RTPASSWD = 'FN#27?Pq';
my $RTPASSWD = '3502c375cb456df70c442cb2f369a854';
my $RTSERVER = 'https://rt.gorillanation.com/';
#my ( $serch,  $vert, $rc, $Grand_query, $sdate, $edate, $header );
my $header = "This is the Header of the monthly script built in perla \n";
my $output = "/var/lib/rt_script/output";
my $sdate = "2013-05-01";
my $edate = "2013-06-01";
my ($q, $vertq);


#	print "give me start and end date in this format YYYY-MM-DD \n";
#	my $sdate = <>;
#	my $edate = <>;
	print "Give me the vertical\n";
	print "These are the options:\nNULL\nAdPlatform\nAtomic_Sites\nCrave(Legacy)\nCrowd_Ignite\nGameRev\nPebblebed\nSales_Integration\nSheknows\nSpringboard_Video\nTechnology_Platform\nunknown\nOther\n\n";
	my $vertq = <>;

#print $sdate;
#print  $edate;
print $vert;
sub  grand_query_perdate{
open OUT, "> $output" or die $!;
#executing a command with perl 
my $Grand_query_perdate=`/var/lib/rt_script/rt ls -o -Created -t ticket " Queue = 'Q_NOC' AND  (  Status = 'open' OR Status = 'new' OR Status = 'stalled' OR Status = 'resolved' ) AND Created > '$sdate 00:00:00' AND Created <= '$edate 23:59:59' AND Subject NOT LIKE 'ZRM' AND Subject NOT LIKE 'Fwd:' AND Subject NOT LIKE 'Re:' "`;
print OUT $header;
print OUT  $Grand_query_perdate;
close OUT;
}
sub query_vertical{
$q = CGI ->new();
$vertq = $q ->param('vertq');
open VER, "> $output" or die $!;
#to pase the data correctly used chomp, to avoid the new line 
chomp($vert);
my $Query_vertical=`/var/lib/rt_script/rt ls -o -Created -t ticket " Queue = 'Q_NOC' AND  (  Status = 'open' OR Status = 'new' OR Status = 'stalled' OR Status = 'resolved' ) AND Created > '$sdate 00:00:00' AND Created <= '$edate 23:59:59' AND Subject NOT LIKE 'ZRM' AND Subject NOT LIKE 'Fwd:' AND Subject NOT LIKE 'Re:'  AND 'CF.{Vertical}' = '$vertq' "`;
print VER $header;
print VER $Query_vertical;
close VER;
}
#&grand_query_perdate;
&query_vertical;
