#!/usr/bin/perl -W

# super quick script to dump nagios' status dump info for a specific service check out to json.

use strict;
use JSON;
use Data::Dumper;

my @keepfields=qw/service_description last_update last_time_ok host_name plugin_output long_plugin_output last_state_change current_state/;
my %bigdata;

my $status="/var/log/nagios/status.dat";

print "Context-Type: text/json\n\n";

my $service;
if (exists $ENV{QUERY_STRING} and $ENV{QUERY_STRING} ne "") {
  $service=$ENV{QUERY_STRING};
} else {
  print "No service description supplied\n";
  exit;
}

open(STATUS,"$status");
while($_=<STATUS>) {
  chomp;
  if (/^servicestatus/) {
    my %littledata=();
    until(/}/) {
      $_=<STATUS>;
      chomp;
      s/^\s+//;
      last if (/}/);
      my ($name,$value)=split("=",$_,2);
      if (grep{$name eq $_}@keepfields) {
         $littledata{$name}=$value;
      }
    }
    if (exists $littledata{"long_plugin_output"}) {
       $littledata{"plugin_output"}.='\\n'.$littledata{"long_plugin_output"};
       delete $littledata{"long_plugin_output"};
    }
    if ($littledata{"service_description"} eq "$service" ) {
      $bigdata{$littledata{"host_name"}}=\%littledata;
    }
  }
}

my $json = new JSON;
my $json_text   = $json->pretty->encode(\%bigdata);
print $json_text;



#servicestatus {
        #host_name=app1v-cacti.tp.prd.lax.gnmedia.net
        #service_description=mysqlstartupconf

