#!/usr/bin/perl -w
use Getopt::Std;
use LWP::Simple;
use Data::Dumper;

# WidgetImp | WidgetCTR | Return Rate
# ALL:  N/A | 1.05/.95 	| 185/180
# CI:   N/A | N/A 	| 160/140
# GR:   N/A | 1.5/1.25 	| 200/180
# CR:   N/A | 1.05/.9 	| 180/170
# MT:   N/A | .80/.70 	| 165/155
# tFS:  N/A | 1/.85 	| 163/150
# TH:   N/A | .7/.6 	| 180/170
# News: N/A | .43 /.35 	| 125/115

sub usage {    print "USAGE:
	-v <VERTICAL> (All,CI,GR,CR,MT,tFS,TH,News)
	-m <METRIC>   (widget_impressions, widget_ctr, return_rate)
	-w <WARNING>
	-c <CRITICAL>
         \n";
    exit;
}

my %opts = ();
getopts('v:m:w:c:d',\%opts); 
@keys = keys %opts;
$size = @keys;
if ($size<4){
   usage();
}

my $vertical = $opts{v};
my $metric  = $opts{m};
my $warning  = $opts{w};
my $critical = $opts{c};
my $debug = $opts{d};

if (!$vertical || !$metric || !$warning || !$critical) {
    usage();
}

my $PageCode = get('http://crowdignite.com/monitor/index');
my @PageCode = split(/\r/, $PageCode);

#All: (Widget Impressions) | (Widget CTR) | (Return Rate)
my $mHash = {};
foreach (@PageCode) {
    my @arr1 = split(/:/, $_);
    my $name = $arr1[0];
    my $values = trim($arr1[1]);
    my @arr2 = split(/\|/, $values);
    my ($wImp,$wCtr,$rRate) = @arr2;
    $mHash->{$name}{'widget_impressions'} = $wImp;    
    $mHash->{$name}{'widget_ctr'} = $wCtr;    
    $mHash->{$name}{'return_rate'} = $rRate;    
}


print Dumper($mHash) if $debug;

if ($mHash->{$vertical}{$metric} <= $critical) {
    print "CRIT: $vertical->$metric =$mHash->{$vertical}{$metric} < $critical\n";
    exit 2;
} elsif ($mHash->{$vertical}{$metric} <= $warning) {
    print "WARN: $vertical->$metric =$mHash->{$vertical}{$metric} < $warning\n";
    exit 1;
} else {
    print "OK: $vertical->$metric =$mHash->{$vertical}{$metric}\n";
    exit 0;
}

##################
##################

sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };
