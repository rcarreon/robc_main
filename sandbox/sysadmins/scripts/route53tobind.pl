#!/usr/bin/perl -w
# Copyright 2010 Amazon.com, Inc. or its
# affiliates. All Rights Reserved. 
#
# Licensed under the Apache License, Version 2.0 (the .License.). You may not
# use this file except in compliance with the License. A copy of the License is
# located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the .license. file accompanying this file. This file is distributed
# on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
# express or implied. See the License for the specific language governing
# permissions and limitations under the License.

=head1 route53tobind.pl

route53tobind.pl - Convert Amazon Route 53 ListResourceRecordSetsResponse XML to a BIND zone file

=head1 SYNOPSIS

This script converts Amazon Route 53 ListResourceRecordSetsResponse XML to a BIND zone file.

Dependencies: XML::Simple, Net::DNS and their dependencies

For help, try:

route53tobind.pl --help

Usage example:

route53tobind.pl < list-response.xml > example.com.zone

=head1 OPTIONS

=over 8

=item B<--help>

Print a help message and exits.

=item B<--origin> [origin]

Specify an origin and reduce the names where possible. (Optional)

=back

=cut

use Data::Dumper;
use warnings;
use strict;
use Net::DNS::RR;
use Getopt::Long;
use Pod::Usage;
use XML::Simple;

my $origin  = "";
my $help    = 0;

my $options = GetOptions(
    "help"          => \$help,
    "origin=s"      => \$origin,
);

if ($help or !$options) {
    pod2usage(1);
    exit;
}

if ($origin && $origin !~ /\.$/) {
    $origin .= ".";
}

# Value to NET::DNS::RR parameters conversion
my $TYPES = {
    A     => sub { my ($v,$r)=@_; 
             $r->{address}=$v; },
    AAAA  => sub { my ($v,$r)=@_; 
             $r->{address}=$v; },
    SOA   => sub { my ($v,$r)=@_; 
             ($r->{mname},$r->{rname},$r->{serial},$r->{refresh},
              $r->{retry},$r->{expire},$r->{minimum}) = split(/ /, $v);
             fndb($r->{mname}); fndb($r->{rname}); },
    NS    => sub { my ($v,$r)=@_; 
             $r->{nsdname}=fndb($v); },
    TXT   => sub { my ($v,$r)=@_; 
             $r->{char_str_list}=[split(/\" \"/,substr($v,1,-1))];},
    CNAME => sub { my ($v,$r)=@_; 
             $r->{cname}=fndb($v); },
    MX    => sub { my ($v,$r)=@_; 
             ($r->{preference}, $r->{exchange}) = split(/ /,$v); 
             fndb($r->{exchange}); },
    PTR   => sub { my ($v,$r)=@_; 
             $r->{ptrdname}=fndb($v); },
    SRV   => sub { my ($v,$r)=@_; 
             ($r->{priority}, $r->{weight}, $r->{port}, $r->{target}) = split(/ /,$v);
             fndb($r->{target}); },
    SPF   => sub { my ($v,$r)=@_; 
             $r->{char_str_list}=[split(/\" \"/,substr($v,1,-1))];},
};

# Fix Net::DNS bug #22019 for version prior 0.64
# Note: this function works both with and without using the return value
sub fndb {
return $_[0];

   if($_[0] =~ /\.$/) {
       $_[0] =~ s/\.$//;
   }
   return $_[0];
}

my $doc;

eval {
    $doc = XMLin(\*STDIN, ForceArray => 1);
};
if(!$doc || $@) {
    die "Failed to parse XML: $@";
}

# Do validation to see if input matches
# the expectations of this tool

#my $rrsetsElement = $doc->[0];

#if(!$rrsetsElement || scalar @$rrsetsElement != 1) {
#    die "Missing ResourceRecordSets element.";
#}

my $rrsetElements = $doc->{ResourceRecordSet};

if(!$rrsetElements || scalar @$rrsetElements == 0) {
    die "Missing ResourceRecordSet elements in ResourceRecordSets.";
}

my $rrsetElement;
my $rrElements;
my $rrElement;

foreach $rrsetElement (@$rrsetElements) {
    my $nameElement = $rrsetElement->{Name};

    if(!$nameElement || scalar @$nameElement != 1) {
        die "Missing Name element in ResourceRecordSet.";
    }

    my $typeElement = $rrsetElement->{Type};

    if(!$typeElement || scalar @$typeElement != 1) {
        die "Missing Type element in ResourceRecordSet.";
    }

    my $recordType = $typeElement->[0];

    if(!$TYPES->{$recordType}) {
        print STDERR "Ignoring ResourceRecordSet with unsupported Type '$recordType'\n";
        next;
    }

    my $ttlElement = $rrsetElement->{TTL};

    if(!$ttlElement || scalar @$ttlElement != 1) {
        die "Missing TTL element in ResourceRecordSet.";
    }

    my $rrsElement = $rrsetElement->{ResourceRecords};

    if(!$rrsElement || scalar @$rrsElement != 1) {
        die "Missing TTL element in ResourceRecordSet.";
    }

    $rrElements = $rrsElement->[0]->{ResourceRecord};

    if(!$rrElements || scalar @$rrElements == 0) {
        die "Missing ResourceRecord element in ResourceRecords.";
    }

    foreach $rrElement (@$rrElements) {
        my $valueElements = $rrElement->{Value};
        if(!$valueElements || scalar @$valueElements != 1) {
            die "Missing Value element in ResourceRecord. ";
        }
    }

}

# Begin actual processing

if($origin) { 
    print "\$ORIGIN $origin\n";
}

foreach $rrsetElement (@$rrsetElements) {
    my $name       = $rrsetElement->{Name}->[0];
    my $type       = $rrsetElement->{Type}->[0];
    my $ttl        = $rrsetElement->{TTL}->[0];
    $name =~ s/\\052/*/;
    $name =~ s/\\100/@/;

    $rrElements = $rrsetElement->{ResourceRecords}->[0]->{ResourceRecord};

    my $params = {
        name  => $name,
        class => "IN",
        type  => $type,
    };

    foreach $rrElement (@$rrElements) {
        my $value = $rrElement->{Value}->[0];
        $params->{ttl} = $ttl;
        $TYPES->{$type}->($value,$params);

        my $rrobj = Net::DNS::RR->new(%$params);
        my $data  = $rrobj->rdatastr || '; no data';

	if ($type eq 'CNAME'){
            print join("\t", $name, $ttl, "IN", $type, $value)."\n";
	} else {
            print join("\t", $name, $ttl, "IN", $type, $data)."\n";
        }
    }
}


