#!/usr/bin/perl
#
# Uses facter(8) to gain learn about the system and inject data back to RT
#
#
use strict;
use Data::Dumper;
use MIME::Base64;

my $debug = 1;

my $rtbin = '/usr/local/bin/rt';
if (! -x $rtbin) {
	print "ASSET UNKNOWN: Can\'t find the rt binary\n";
	exit 3;
}

my $facterbin = '/usr/bin/facter';
if (! -x $rtbin) {
	print "ASSET UNKNOWN: Can\'t find the rt binary\n";
	exit 3;
}

my $rtuser = 'root';
my $rtpasswd = decode_base64('d2FzYWJp');
my $rtserver = 'https://rt.lax3.gnmedia.net/';

my $rtout = `$facterbin`;
my @lines = split(/\n/,$rtout);
my $facterval;
foreach my $line (@lines) {
	#print "$line\n" if $debug;
	if ($line =~ /^(\w+)\s*=>\s*(.+)$/) {
		#print "found $1 -map- $2\n" if $debug;
		$facterval->{$1} = $2;
	}
}

print Dumper($facterval), "\n" if $debug;

if (! exists $facterval->{'at_id'}) {
	print "ASSET UNKNOWN: at_id field not found in facter\n";
	exit 2;
}

my $assetid = $facterval->{'at_id'};

#
# Once we've gathered our facts, we'll decide what to rationalise with a map
#
my $atfields = {
	'fqdn'			=> 'name',
	'lsbdistid'		=> 'os',
	'lsbdistrelease'	=> 'osversion',
	'macaddress'		=> 'kickstartmacaddress',
	'memorysize'		=> 'memory',
};
print Dumper($atfields), "\n" if $debug;

my $editcmds = "$rtbin edit $assetid set";
my ($atprefix,$atsuffix);

foreach my $key (keys(%$atfields)) {
	if ($key eq 'fqdn') {
		$atprefix = '';
		$atsuffix = '';
	} else {
		$atprefix = 'cf-';
		$atsuffix = '';
	}
	if (exists($facterval->{$key}) && 
	   ($facterval->{'at_' . $atfields->{$key}} eq $facterval->{$key})) {
		print "$key is found and safe\n" if $debug;
	} else {
		$editcmds .= " $atprefix".$key."$atsuffix=\'".$facterval->{$key}."\'";
	}
}
print "auto-section $editcmds\n" if $debug;

#
# In this section we parse the CPU stats
#
if (exists($facterval->{'physicalprocessorcount'})) {
	$editcmds .= " cf-cpu=\'";
	for (my $i = 0; $i < $facterval->{'physicalprocessorcount'}; $i++) {
		$editcmds .= $facterval->{"processor$i"} . ",";
	}
	chop($editcmds);
	$editcmds .= "\'";
}
print "memory-section $editcmds\n" if $debug;
