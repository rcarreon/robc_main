#!/usr/bin/perl
#
# Script that will parse the reports from cgi and pretty-print a sorted list
#
use strict;

$ENV{'REQUEST_METHOD'} = 'GET';
$ENV{'REMOTE_USER'} = 'admin';
if (! exists($ENV{'QUERY_STRING'})) {
	$ENV{'QUERY_STRING'} = 'show_log_entries=&servicegroup=HTTP&timeperiod=last7days&assumeinitialstates=yes&assumestateretention=yes&assumestatesduringnotrunning=yes&includesoftstates=no&initialassumedhoststate=3&initialassumedservicestate=6&backtrack=4';
}

my @html = split(/\n+/,`/usr/lib64/nagios/cgi-bin/avail.cgi`);

my $printon = 1;
my $rewritestart = 0;
foreach my $line (@html) {
	if (!$rewritestart) {
		if ($line =~ /^[<]form/) {
			# Drop the report query generator
			$printon = 0;
			next;
		}
		if ($line =~ /^[<]\/form/) {
			# End of the query gneerator code
			$printon = 1;
			next;
		}
		if ($line =~ /^[<]DIV ALIGN=CENTER CLASS=[']dataTitle['][>]Servicegroup [']HTTP['] Host State Breakdowns:[<]\/DIV[>]/) {
			# Drop the first host section
			$printon = 0;
			next;
		}
		if (!$printon && $line =~ /^[<]\/?BR[>]/) {
			$printon = 1;
			$rewritestart = 1;
		}
	} else {
		if ($line =~ /^[<]TR[>][<]TH /) {
			$line = '<TR><TH CLASS=\'data\'>Service</TH><TH CLASS=\'data\'>% Time OK</TH>';
		} elsif ($line =~ /^([<]tr CLASS=\'data(:?Even|Odd)\'[>])[<]td CLASS=\'data(:?Even|Odd)\'[>]/) {
			my $head = $1;
			my $tail = '</td></tr>';
			my ($service,$crit) = 
				$line =~ /^[<]tr .*?[>][<]td .*?[>][<]\/td[>]([<]td .*?[>].*?OK\'[>]).*?CRITICAL.*?[(](\d+\.\d+)[%][)]/;
			$service =~ s/ https?-\d+//i;
			$crit = 100 - $crit;
			if ($crit < 99) {
				$service =~ s/serviceOK/serviceCRITICAL/;
			} elsif ($crit < 99.9) {
				$service =~ s/serviceOK/serviceWARNING/;
			}
			$line = $head . $service . sprintf("%.3f",$crit) . $tail;
		} elsif ($line =~ /Average/) {
			my ($crit) = $line =~ /CRITICAL.*?[(](\d+\.\d+)[%][)]/;
			$crit = 100 - $crit;
			$line = '<tr CLASS=\'dataOdd\'><td CLASS=\'dataOdd\'>Average</td><td CLASS=\'serviceOK\'>' .
				sprintf("%0.3f",$crit) . '</td></tr>';
		}
	}
	print "$line\n" if $printon;
}
