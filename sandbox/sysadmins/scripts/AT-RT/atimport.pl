#!/usr/bin/perl
#
use RT::Client::REST;
use Text::CSV_XS;
use strict;
use Getopt::Long;

my $debug=0;
my $help=0;
my ($noop,$replace_only);
my $error;
my $server="rt.gorillanation.com";
my $user="root";
my $pass="password";
my $keyid="Name";
my $object_type="asset";
my ($id,$ret,$filename,$fh);

my %mandatory_create_fields = (
	"Name" => 1,
	"Type" => 1,
	"CF-CompanyAssetTAG" => 1,
	"CF-Manufacturer" => 1,
	"CF-Model" => 1,
	"CF-Site" => 1,
	"CF-Silo" => 1,
	"CF-ServerStatus" => 1,
);

Getopt::Long::Configure('bundling');
GetOptions
       ("f=s"   => \$filename, "filename=s"     => \$filename,
	"u=s"   => \$user, "user=s" => \$user,
	"p=s"   => \$pass, "password=s" => \$pass,
	"t=s"   => \$object_type, "type=s" => \$object_type,
	"s=s"   => \$server, "server=s" => \$server,
	"k=s"   => \$keyid, "key=s" => \$keyid,
	"n"	=> \$noop, "noop" => \$noop,
	"r"	=> \$replace_only, "replace" => \$replace_only,
	"d"     => \$debug, "debug" => \$debug,
	"h"     => \$help, "help" => \$help,
	);

my $rt = RT::Client::REST->new(
	server => "https://$server/",
	timeout => 30,
);

check_parameters();

warn "Using $user $pass $object_type $filename\n" if $debug;

my $csv = Text::CSV_XS-> new();
open ($fh,"<",$filename) || die "$filename: $!";
my @columns = $csv->getline($fh);
foreach my $field (keys(%mandatory_create_fields)) {
	my @match = grep(/^\Q$field\E$/,@columns);
	if ($#match) {
		next;
	} else {
		die "Missing mandatory column header $field\n";
	}
}
$csv->column_names(@columns);
if ($error = $csv->error_diag()) {
	die "$error";
}

# No error checking for the next line, it will "die" with appropriate message
$rt->login(username => $user, password => $pass);

while (my $row=$csv->getline_hr($fh)) {
	if ($debug) {
		foreach my $key (keys(%$row)) {
			print "$key = $row->{$key}\n";
		}
	}
	if ($error = $csv->error_diag()) {
		print "$error";
	}
	if (exists($row->{$keyid})) {
		$row->{$keyid} = lc($row->{$keyid});
		my $query_string = "$keyid = \'" . $row->{$keyid} . "\'";
		($id) = $rt->search(type => $object_type, query => $query_string);
		if ($id) {
			# Existing asset will be 'edit'ed
			print "Updating $object_type id $id $query_string ";
		} else {
			# New asset to create
			print "Creating new $object_type $query_string ";
			$id = "new";
		}
		if ($noop || ($id == "new" && $replace_only)) {
			print "...not really, skipping\n";
		} else {
			$rt->edit(type => $object_type, id => $id, set => $row);
			print "...done.\n";
		}
	} else {
		warn "Skipping line $.\n";
	}
}

close ($fh) or die "$filename: $!";
print "\n";

sub check_parameters {
	if ($help) {
		print_usage();
		exit 0;
	}
	if (!$filename) {
		print_usage();
		die "\nYou must supply a filename!\n";
	}
}

sub print_usage {
	print "Imports data into AT\n\n";
	print "-h, --help\n\tPrint help message\n";
	print "-d, --debug\n\tTurn on debugging\n";
	print "-n, --noop\n\tDo not actually update or create\n";
	print "-r, --replace\n\tReplace/update only, do not create\n";
	print "-k, --key=COLUMNNAME\n\tThe uniqe column key to search for assets, default is \"$keyid\"\n";
	print "-u, --username=USER\n\tThe username for AT, default is $user\n";
	print "-p, --password=PASS\n\tThe password for AT, default is $pass\n";
	print "-s, --server=HOST.EXAMPLE.COM\n\tThe master REST server, default is $server\n";
	print "-f, --filename=FILE.CSV\n\tThe csv format file to import\n";
}

#$asset = $rt->show(type => $object_type, id => $id);
#if ($error = Exception::Class->caught('RT::Client::REST::UnauthorizedActionException')) {
#	print "You are not authorized to view ${object_type}/$id\n";
#} 
