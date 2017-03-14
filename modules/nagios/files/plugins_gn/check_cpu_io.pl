#!/usr/bin/env perl

use strict;
use Getopt::Long;

my %status = (
    OK       => 0,
    WARNING  => 1,
    CRITICAL => 2,
    UNKNOWN  => 3,
);

sub get_stats {
  exit $status{UNKNOWN} unless -f '/proc/stat';

  open my $fh, '<', '/proc/stat';
  my $line = <$fh>; # First line gets us the summary of cpus
  close $fh;

  (split /\s+/, $line)[1, 3, 4, 5]; # user, system, idle, iowait
}

sub main {
  my ($warning, $critical); # Alert thresholds

  GetOptions
    'warning|w=i' => \$warning,
    'critical|c=i' => \$critical;

  # The same thresholds EM uses
  $warning = 20 unless defined $warning;
  $critical = 25 unless defined $critical;

  my ($user, $system, $idle, $iowait) = get_stats;
  my $criteria = ($iowait / ($idle + $iowait + $user + $system)) * 100;
  my $message = sprintf ' - CPU I/O Usage Excessive: ' .
                        "(%d / (%d + %d + %d + %d)) * 100 = %g\n",
			$iowait, $idle, $iowait, $user, $system, $criteria;

  if ($criteria > $critical) {
    print 'CRITICAL' . $message;
    exit $status{CRITICAL};
  }
  elsif ($criteria > $warning) {
    print 'WARNING' . $message;
    exit $status{WARNING};
  }

  print 'OK' . $message;
  exit $status{OK};
}

main;
