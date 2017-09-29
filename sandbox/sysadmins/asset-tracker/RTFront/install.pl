
use strict;
use warnings;
use Getopt::Long;

my $dest_dir = '/usr/local/QuickTicket';
my $rt_url = 'rt.gnmedia.net';
my $qt_url = 'qt.gnmedia.net';

my $results = GetOptions ("destination=s" => \$dest_dir,
                          "rt_url=s"      => \$rt_url,
			  "qt_url=s"      => \$qt_url);

if (!$results) {
    print "Usage: \n";
    print "  --destination=<path> path where QuickTicket files are placed\n";
    print "  --rt_url=<url>       url for rt server (do not include 'http://')\n";
    print "  --qt_url=<url>       url for QuickTicket (do not include 'http://')\n";
    exit(-1);
}

open (CONFIGFILE, '>lib/RTFront/Config.pm') 
   || die("Cannot open file config file: lib/RTFront/Config.pm: $!");
print CONFIGFILE "package RTFront::Config;\n\n";
print CONFIGFILE "our \$QT_PATH = '$dest_dir';\n";
print CONFIGFILE "our \$RT_URL = '$rt_url';\n";
print CONFIGFILE "our \$QT_URL = '$qt_url';\n\n";
print CONFIGFILE "1;";
close (CONFIGFILE); 

unless (-e $dest_dir) {
    mkdir $dest_dir 
        || die ("Cannot create destination path $dest_dir\n");
}

print `perl Makefile.PL`;
print `make`;
print `make install`;
print `cp -R templates/* $dest_dir`;
print `perl make_objects.pl`;


