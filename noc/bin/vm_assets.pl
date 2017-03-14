#!/usr/bin/env perl

use strict;
use warnings;

use Carp qw/confess/;
use Data::Dumper qw/Dumper/;

use constant {
  SCALAR => 1,
  ARRAY => 2,
  HASH => 3,
};

my %metric = (
  memory => {
    command => {
      dev => q{ nodels vm@dev vm.memory },
      stg => q{ nodels vm@stg vm.memory },
      prd => q{ nodels vm@prd vm.memory },
    },
    handler => \&memory_cpus,
    type => SCALAR,
  },
  cpus => {
    command => {
      dev => q{ nodels vm@dev vm.cpus },
      stg => q{ nodels vm@stg vm.cpus },
      prd => q{ nodels vm@prd vm.cpus },
    },
    handler => \&memory_cpus,
    type => SCALAR,
  },
  df_Pm => {
    # The -P flag allows df not to break lines when they get long enough, this
    # makes output parsing easier. The -m one changes the the way storage
    # units are displayed, from 1K-blocks to 1M-blocks.
    command => {
      dev => q{ psh vm@dev 'df -Pm' },
      stg => q{ psh vm@stg 'df -Pm' },
      prd => q{ psh vm@prd 'df -Pm' },
    },
    handler => \&df_Pm,
    type => ARRAY,
  },
);

# regex to parse the output of "nodels" and "psh"
my $parser = qr{
^
  (?<box>.+?              # FQDN
    \.(?<vertical>.+?)
    \.(?<environment>.+?)
    \..+?
  )
  :                       # field separator
  \s+
  (?<data>.+)             # the actual meat
$
}x;

sub process {
  my ($metric, $environment, $vm) = @_;

  open my $fh, '-|', $metric{$metric}{command}{$environment};

  while (my $line = <$fh>) {
    if($line =~ /$parser/) {
      if ($metric{$metric}{type} == SCALAR) {
	$vm->{$+{vertical}}{$+{environment}}{$+{box}}{$metric}
	  = $metric{$metric}{handler}->($+{data});
      }
      elsif ($metric{$metric}{type} == ARRAY) {
	push @{$vm->{$+{vertical}}{$+{environment}}{$+{box}}{$metric}},
	  $metric{$metric}{handler}->($+{data});
      }
      elsif ($metric{$metric}{type} == HASH) {
	confess "handling of HASH types unimplemented";
      }
    }
  }

  close $fh;
}

## Handlers ##################################################################

sub memory_cpus {
  shift;
}

sub df_Pm {
  my %disk;

  @disk{qw/filesystem size used avail use% mounted_on/}
    = split /\s+/, shift;

  \%disk;
}

## Util ######################################################################

my @disk_summary_keys = (
  'disk: no-nfs volumes',
  'disk: only nfs volumes',
  'disk: total without /home mount point (if /home is nfs)',
  'disk: total',
);

sub disk_in_depth {
  my @disks = @{$_[0]};
  my ($total, $no_nfs, $nfs, $home);
  my $is_home_nfs = 0;

  # discard header
  shift @disks;

  for my $disk (@disks) {
    $total += $disk->{size};
    $no_nfs += $disk->{size} unless $disk->{filesystem} =~ /^nfs/;
    $nfs += $disk->{size} if $disk->{filesystem} =~ /^nfs/;

    if ($disk->{mounted_on} eq '/home') {
      $home = $disk->{size};
      $is_home_nfs = 1 if $disk->{filesystem} =~ /^nfs/;
    }
  }

  {
    "$disk_summary_keys[0]" => $no_nfs,
    "$disk_summary_keys[1]" => $nfs,
    "$disk_summary_keys[2]" => $is_home_nfs ? $total - $home : $total,
    "$disk_summary_keys[3]" => $total,
  };
}

sub summary {
  my %vm = @_;
  my %summary;
  my @keys;

  while (my ($vertical, $values) = each %vm) {
    while (my ($environment, $values) = each %$values) {
      while (my ($box, $values) = each %$values) {
	$summary{node}{$vertical}{node}{$environment}{node}{$box}{summary} = {
          %{disk_in_depth $values->{df_Pm}},
	  map { $_ => $values->{$_} } qw/memory cpus/,
	};

	@keys = keys %{$summary{node}{$vertical}{node}{$environment}{node}{$box}{summary}}
	  unless @keys;

	$summary{node}{$vertical}{node}{$environment}{summary}{$_}
	  += $summary{node}{$vertical}{node}{$environment}{node}{$box}{summary}{$_}
	    for @keys;
      }
      $summary{node}{$vertical}{summary}{$_}
	+= $summary{node}{$vertical}{node}{$environment}{summary}{$_}
	  for @keys;
    }
    $summary{summary}{$_} += $summary{node}{$vertical}{summary}{$_}
      for @keys;
  }
  
  %summary;
}

sub report_csv {
  my %summary = @_;
  my @keys = (qw/memory cpus/, @disk_summary_keys);

  while (my ($vertical, $values) = each %{$summary{node}}) {
    print $vertical, "\n";
    while (my ($environment, $values) = each %{$values->{node}}) {
      print $environment, "\n";
      printf "%s\n", join ',', 'box', @keys;
      while (my ($box, $values) = each %{$values->{node}}) {
	printf "%s\n", join ',', $box, map { $values->{summary}{$_} } @keys;
      }
      printf "%s\n", join ',', "$environment total", map { $values->{summary}{$_} } @keys;
    }
    printf "%s\n", join ',', "$vertical total", map { $values->{summary}{$_} } @keys;
  }
  printf "%s\n", join ',', 'grand total', map { $summary{summary}{$_} } @keys;
}

##############################################################################

sub main {
  my %vm;

  for my $environment (@_) {
    process $_, $environment, \%vm for keys %metric;
  }

  print STDERR Dumper \%vm if $ENV{DEBUG};

  report_csv summary %vm;
}

main @ARGV if @ARGV;

__END__
=pod

=head1 NAME

vm_assets.pl - query and report

=head1 SYNOPSIS

The way you normally want to run the script is as follows.

  vm_assets.pl dev stg prd > report_$(date +%F).csv

If you are curious on how data is being stored by the script, e.g. for
debugging purposes.

  DEBUG=1 vm_assets.pl dev 2>&1 | less

=head1 DESCRIPTION

Though vm_assets.pl uses both C<nodels> and C<psh> under the hood, it eases
the pain of processing what they make available.

It displays, classifies and summarizes data in such a way that exporting to an
arbitrary representation isn't as painful as walking on pins and needles.

Currently it only supports the B<csv> format as output, but can be extended to
suport more.

=head1 AUTHOR

Israel Fimbres
