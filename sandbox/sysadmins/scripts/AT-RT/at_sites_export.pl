#!/usr/bin/perl

use strict;
use atsqlexport;
use Data::Dumper;
use Net::DNS;
use File::Path;
use MIME::Base64;

my $debug=1;


# Generate AT data hash
my $at = Infrastructure::AT->new( server => 'DBI:mysql:rt3:rt.lax3.gnmedia.net:3306', user => 'deploy', pass => decode_base64('eTFweTFwIQ=='));

my $fields = [ 'Name', 'Status', 'MonitorPriority', 'MonitorProtocol', 'MonitorPortNumber', 'MonitorResultString', 'MonitorURLPath', 'BusinessOwner' ];
my $where = { Type => 'Site', Status => 'Production' };

my $items = $at->getAssets(fields => $fields, where => $where);
#print Dumper($items) if $debug;

foreach my $site (values(%$items)) {
    my $skip = 0;
    print $site->{"Name"} ."\n" if $debug;
    next;
}
