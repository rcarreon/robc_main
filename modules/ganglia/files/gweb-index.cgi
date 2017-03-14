#!/usr/bin/perl

# gweb-index, the frontpage of gweb!

# This script is necessary because gweb "grid" integration is weak sauce. Maybe
# one day they can take it to the County Fair, but for now, it is weak sauce.

#print "\n\n";

use strict;

my @verticals=qw/ao ap ci og sbv si tp/;
my $gweblinks=<<__EOF__;
<br>Our gweb servers...
<br><a href="http://ao.gweb.gnmedia.net/">ao.gweb.gnmedia.net</a>
<br><a href="http://ap.gweb.gnmedia.net/">ap.gweb.gnmedia.net</a>
<br><a href="http://ci.gweb.gnmedia.net/">ci.gweb.gnmedia.net</a>
<br><a href="http://og.gweb.gnmedia.net/">og.gweb.gnmedia.net</a>
<br><a href="http://sbv.gweb.gnmedia.net/">sbv.gweb.gnmedia.net</a>
<br><a href="http://si.gweb.gnmedia.net/">si.gweb.gnmedia.net</a>
<br><a href="http://tp.gweb.gnmedia.net/">tp.gweb.gnmedia.net</a>
__EOF__


# Get our input(s)
use CGI;
my $q = CGI->new;
my @values  = $q->param('h');
my $hostname=$values[0];
my $form="<form action=\"".$ENV{SCRIPT_NAME}."\">\nHostname (regex) (must include vertical): <input name=\"h\" value=\"$hostname\">\n</form>\n";
if (!$hostname) {
  print "Content-type: text/html\n\n<html><body><h2>The frontpage of gweb!</h2>$form$gweblinks</body></html>";
  #print map { "$_=>".$ENV{$_}."<br>"} keys %ENV;
  exit(0);
}

my $vertical= (split(/[.]/,$hostname))[1];
foreach my $a (@verticals) {
   if ($hostname =~ m/\b$a\b/) {
      $vertical=$a;
   }
}
if (!$vertical) {
   print "Content-type: text/html\n\n<html><body>Can't parse out the vertical<br></body></html>";
}



# Get the XML DATA from the proper gweb server
use IO::Socket::INET;
my ($socket,$client_socket);
$socket = new IO::Socket::INET (
   PeerHost => "$vertical.gweb.gnmedia.net",
   PeerPort => '8651',
   Proto => 'tcp',
) or die "\n\nERROR in Socket Creation to $vertical.gweb.gnmedia.net : $!\n";

undef $/;
my $data = <$socket>;



# parse the XML
use XML::Simple;
my $ref = XMLin($data);


# parse the input data
my $results=0;
my %reskeys=();

my @clusters= @{ $ref->{GRID}{CLUSTER} };
#print map {$_->{NAME}} @clusters;
foreach my $cluster (@clusters) {
   next unless $cluster->{HOST};
   my $clustername=$cluster->{NAME};
   if (ref $cluster->{HOST} eq "HASH") {
      # one host in this cluster
      if ($cluster->{HOST}->{NAME} =~ /$hostname/) {
          $reskeys{$clustername}{$cluster->{HOST}->{NAME}}=1;
          $results++;
      }
   } elsif (ref $cluster->{HOST} eq "ARRAY") {
      # multiple hosts in this cluster
      foreach my $host (@{ $cluster->{HOST} }) {
         if ($host->{NAME} =~ /$hostname/) {
             $reskeys{$clustername}{$host->{NAME}}=1;
             $results++;
         }
      }
   } else {
      die;
   }
}



# output
$ENV{QUERY_STRING} =~ s/h=[^&]*&//;
$ENV{QUERY_STRING} =~ s/h=[^&]*$//;
$ENV{QUERY_STRING} =~ s/&&/&/;
if ($results == 1) {
   my ($cluster) = keys %reskeys;
   my ($host) = keys %{ $reskeys{$cluster} };
   print "Location: http://$vertical.gweb.gnmedia.net/?c=$cluster&h=$host&".$ENV{QUERY_STRING}."\n\n";
   #
} elsif ($results > 1) {
   print "Content-type: text/html\n\n<html><body>$form";
   print "Multiple results:";
   foreach my $cluster (sort keys %reskeys) {
      print "<h3><a href=\"http://$vertical.gweb.gnmedia.net/?c=$cluster&&".$ENV{QUERY_STRING}."\">$cluster</a></h3>\n";
      foreach my $host (sort keys %{ $reskeys{$cluster} }) {
         print "<a href=\"http://$vertical.gweb.gnmedia.net/?c=$cluster&h=$host&".$ENV{QUERY_STRING}."\">$host</a><br>";
      }
   }
   print "$gweblinks</body></html>\n";

} else {
   print "Content-type: text/html\n\n<html><body>Not found, bro.<br>$form</body></html>";
}

