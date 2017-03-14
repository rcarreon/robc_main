#!/usr/bin/perl 

# $Id$
# $URL$

#===============================================================================
#
#         FILE: checklogin.pl
#
#        USAGE: 
#
#  DESCRIPTION:  
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Tim Pretlove
#      COMPANY:  University of Liverpool
#      VERSION:  0.4
#      CREATED:  19-08-2010 10:37
#     MODIFIED:  30-03-2011 11:22
#      LICENCE: GNU
#      
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#    
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#    
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#===============================================================================

use strict;
use warnings;

use HTTP::Request::Common qw(POST);
use LWP::UserAgent;
use Getopt::Long;
use Time::HiRes qw(gettimeofday tv_interval);
#use lib "/usr/local/nagios/libexec";
#use utils qw(%ERRORS);

my ($get,$nofor,$help,$crit, $warn, $debug, $expect, $form, $url,$ver,$status);

GetOptions(
	'crtitical=s'	=> \$crit,
	'warning=s'		=> \$warn,
	debug			=> \$debug,
	noforward		=> \$nofor,
	'expect=s'		=> \$expect,
	'form=s'		=> \$form,
	'url=s'			=> \$url,
	status			=> \$status,
	get				=> \$get,
	help			=> \$help,
	verbose			=> \$ver ) or HELP_MESSAGE();
	
if (defined $help) {
	HELP_MESSAGE();
}


sub testauth {
    my ($get,$nofor,$help,$crit, $warn, $debug, $expect, $form, $url,$ver,$status) = @_;
    my $startsec;
    my $elapsed;
	my $ua = new LWP::UserAgent;
	my $timeout = $crit + 1;
	my %inputHash;
	my $response;
	my $httpchk = substr $url, 0, 4; 
	if ($httpchk ne "http") { $url = "http://" . $url }
	$ua->cookie_jar( {} );
    $ua->timeout($timeout);
	if (!defined $nofor) {
		$ua->requests_redirectable (['GET', 'HEAD', 'POST']);
	}
	my @formInput = split('&',$form);
	foreach (@formInput) {
		my ($name,$value) = split('=');
		$inputHash{$name} = $value;
	}
	$startsec = [gettimeofday()];
	$ua->agent('Mozilla/4.76 [en] (Windows NT 5.0; U)');
	my $req;
	eval {
		local $SIG{ALRM} = sub { die "timeout" };
		alarm($timeout);
		$req = POST $url, [ %inputHash ];
		$response = $ua->request($req);
		alarm(0);
	};
	if ($@) {
		$elapsed = tv_interval ($startsec, [gettimeofday]);
		return 3, $elapsed;
	}
	my $rescont = $response->content;
	my $resstat = $response->status_line;
	$elapsed = tv_interval ($startsec, [gettimeofday]);
	if (defined $debug) {
		print "$rescont\n";
	}
	if (defined $status) {
		print "$resstat\n";
	}
	if ((defined $crit) && (defined $warn)) {
		if ($crit <= $elapsed) { return 3, $elapsed }
		if ($warn <= $elapsed) { return 2, $elapsed }
	}
	if ($response->content !~ /$expect/) {	
		return 4, $elapsed;
	}
	return 0, $elapsed;
}

sub checkopts {
    my ($get,$nofor,$help,$crit, $warn, $debug, $expect, $form, $url,$ver,$status) = @_;
	if ((!defined $url) || (!defined $expect) || (!defined $form)) {
		print "-u <url> -e <expect> -f <form> need to be specified\n";
		HELP_MESSAGE();
		exit 4;
	}

	if ((defined $ver) && ((!defined $crit) || (!defined $warn))) {
		print "-v needs -c and -w values to be specified\n";
		HELP_MESSAGE();
		exit 4;
	}
	if (((defined $warn) && (!defined $crit)) || ((defined $crit) && (!defined $warn))) {
		print "Both -w and -c need to be specified\n";
		HELP_MESSAGE();
		exit 4;
	}
    return 1
}

sub HELP_MESSAGE {
	print "$0 -u <url> -f <formstring> -e <expect> (-c <critical> -w <warning>)\n";
	print "\t -u <url> # url string to post form data against\n";
	print "\t -e <expect> # string to query on the authenticated page\n";
	print "\t -f <sting> # post string\n";
	print "\t -c <seconds> # the number of seconds to wait before a going critical\n";
	print "\t -w <seconds> # the number of seconds to wait before a flagging a warning\n";
	print "\t -n do not follow redirection\n";
	print "\t -d prints page contents (debugging info)\n";
	print "\t -s prints status code (debugging info)\n";
	print "\t e.g $0 -u https://foobar.com -f \"login=foo&password=bar\" -e \"Hello sweetie\" -c 10 -w 3 -v \n";
	exit 0;
}

checkopts($get,$nofor,$help,$crit, $warn, $debug, $expect, $form, $url,$ver,$status);
my ($rc,$elapsed) = testauth($get,$nofor,$help,$crit, $warn, $debug, $expect, $form, $url,$ver,$status);
my @mess = qw(OK CRITICAL WARNING CRITICAL CRITICAL);
my @mess2 = ("host authenticated successfully","authentication failed","is slow responding","host critical response time","failed to retrieve expect string");
print "HTTPFORM $mess[$rc]: $mess2[$rc]";
if ($ver) {
	print "|time=$elapsed" . "s;$warn;$crit;0;$crit";
}

if ($rc == 0) { exit 0 }
if ($rc == 1) { exit 2 }
if ($rc == 2) { exit 1 }
if ($rc == 3) { exit 2 }
if ($rc == 4) { exit 2 }

