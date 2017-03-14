#!/usr/bin/perl
# $Id$
use strict;
use warnings;

my $archive = '/app/data/archive';
my $whisperdata = '/app/data/storage/whisper';
my @datadirs = `ls -1 $whisperdata`;

foreach (@datadirs) {
  chomp;

  my $lastmod = `find $whisperdata/$_ -type f -printf '%T@\\n' | sort -k 1nr | head -1`;
  chomp $lastmod;
  my $current = time();
  my $timediff = $current - $lastmod;

  # 604800 is one week in secs.
  if ($timediff > 604800) {
    system("cd $whisperdata; tar czf $archive/$_-\$(date +%Y%m%d%H%M%S).tar.gz $_ && rm -rf $whisperdata/$_");
  }
} 
