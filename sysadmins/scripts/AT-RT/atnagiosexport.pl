#!/usr/bin/perl

use lib "/home/deploy/AT-RT";
use strict;
use atsqlexport;
use Data::Dumper;
use Net::DNS;
use File::Path;
use MIME::Base64;

my $debug=0;

my $generatedir = "/var/tmp/nagios/nagios/files/external/conf.d/auto";
my $hostsdir = $generatedir . "/hosts";
my $hostgroupsdir = $generatedir . "/hostgroups";
my $servicesdir = $generatedir . "/services";
my $servicegroupsdir = $generatedir . "/servicegroups";
my $servicedepsdir = $generatedir . "/servicedeps";
my $serviceescalationdir = $generatedir . "/serviceescalations";

# Generate AT data hash
my $at = Infrastructure::AT->new( server => 'DBI:mysql:rt3:vip-sqlrw-inv.tp.prd.lax.gnmedia.net:3306', user => 'rtscripts_r', pass => decode_base64('Y25za2dSaUg='));

my $fields = [ 'Name', 'Status', 'MonitorPriority', 'MonitorProtocol', 'MonitorPortNumber', 'MonitorResultString', 'MonitorURLPath', 'BusinessUnit' ];
my $where = { Type => 'Site', Status => 'Production' };

my $items = $at->getAssets(fields => $fields, where => $where);
#print Dumper($items) if $debug;

my $iphash;
my $sitehash;
my $iplookup;
my $RRrecord;
my $resquery;
my $answer;
my $hostgrouphash;
my $servicegrouphash;
my $intres = Net::DNS::Resolver->new;
my $extres = Net::DNS::Resolver->new(nameservers => [qw(4.2.2.2 4.2.2.1)]);
$intres->udp_timeout(10);
$intres->udp_timeout(3);

foreach my $site (values(%$items)) {
    my $skip = 1;
        if ($site->{"Name"} =~ m{/}) { next; }  # Site URL, not a DNS name 
	if (!($site->{"MonitorPriority"}) || $site->{"MonitorPriority"} =~ /off/i) {
		print "Skipping ", $site->{"Name"}, " MonitorPriority off\n" if $debug;
		next;
	}
	# Form the DNS-IP bindings
	$resquery = $extres->query($site->{"Name"},'A');
        if ($resquery) {
	my @answer = $resquery->answer;
		foreach $RRrecord (@answer) {
                        $skip = 0;
			if ($RRrecord->{"type"} eq 'A' || $RRrecord->{"type"} eq 'PTR') {
				$iplookup = $RRrecord->{"address"};
				if ($RRrecord->{"type"} eq 'PTR' and !$iplookup) {
					$iplookup = $site->{"Name"};
					print "Site ", $site->{"Name"}, " looks like an ip, we are using it as sitename and ip\n" if $debug;
				}
				print "Found ip $iplookup for ",$site->{"Name"},"\n" if $debug;
                $iphash->{$iplookup}->{"naghostname"} = $iplookup;
				# Instantiate a site record
				$sitehash->{$site->{"Name"}}->{"assetid"} = $site->{"id"};
				$sitehash->{$site->{"Name"}}->{"host_name"} = $iplookup;
			} else {
				print "Found ",$RRrecord->{"type"}, " for ",$site->{"Name"},"\n" if $debug;
			}
		}
	}
    if ($skip) {print "No DNS for ",$site->{"Name"}, ", skipping.\n";next;}
	# Set the defaults for missing fields
	if (!$site->{"MonitorProtocol"}) {
		$items->{$site->{"id"}}->{"MonitorProtocol"} = "HTTP";
	}
	if (!$site->{"MonitorPortNumber"}) {
		$items->{$site->{"id"}}->{"MonitorPortNumber"} = ["80"];
		$site->{"MonitorPortNumber"} = ["80"];
	}
	# Instantiate a list of ports associated with the IP
	my $portlist = $site->{"MonitorPortNumber"};
	foreach my $portnumber (@$portlist) {
		$iphash->{$iplookup}->{"ports"}->{$portnumber} = 1;
	}
}
print "Found ",scalar keys %{$sitehash}," site objects\n";
if (20 > scalar keys %{$sitehash}) {
   print STDERR "Something went wrong.\n";
   exit 1;
}

print Dumper($items) if $debug;
print Dumper($sitehash) if $debug;

my $autogenhead = '# File auto-generated '.localtime()."\n\n".'# Please dont edit these files manually'."\n".'#All changes will be lost on next run'."\n";

sub create_dir {
    my $dir = shift;
    my $text = shift;
    if (! -d $dir) {
	    mkpath($dir) || die;
        open (README,">${dir}/README.TXT") || die "Cant create ${dir}/README.TXT\n";
        print README $text;
        close (README);
    }
}

create_dir($hostsdir,$autogenhead);
create_dir($servicesdir,$autogenhead);

my $revhostlookup;
my $parenthostname;
my $defaultparenthost = "core1.gnmedia.net";

# Create the base host files
foreach my $parenthost (keys(%$iphash)) {
	$resquery = $intres->query($parenthost,'PTR');
    #print Dumper($answer) if $debug;
        if ($resquery) {
                my @answer = $resquery->answer;
		$revhostlookup = $answer[0]->{"ptrdname"};
		$iphash->{$parenthost}->{"naghostname"} = $revhostlookup;
	} else {
		$revhostlookup = $parenthost;
	}
	if (!$revhostlookup) { $revhostlookup = $parenthost; }
	#open (PARENTFILE, ">${hostsdir}/vip-$revhostlookup.cfg") || die "Cant create ${hostsdir}/$revhostlookup.cfg\n";
	#print PARENTFILE "define host {\n\tuse\t\tgeneric-host\n";
	#print PARENTFILE "\tparents\t\t$defaultparenthost\n";
	#print PARENTFILE "\thost_name\t$revhostlookup\n";
	#print PARENTFILE "\talias\t\t$revhostlookup\n";
	#print PARENTFILE "\taddress\t\t$parenthost\n";
	#print PARENTFILE "}\n";
	#close (PARENTFILE);
	#print `cat ${hostsdir}/vip-$revhostlookup.cfg` if $debug;

	#my $portlist = $iphash->{$parenthost}->{"ports"};
	#foreach my $portnumber (keys(%$portlist)) {
		#my $servicepriority = "high-priority-service";
		#my $check_command = "check_tcp!$portnumber";
		#if ($portnumber == 443) { # Check for expired certs instead of port number
			#$check_command = "check_http!-C 45";
			#$servicepriority = "ssl-service";
		#}
		#open (SERVICEFILE, ">${servicesdir}/tcpports-$revhostlookup-$portnumber.cfg")|| die "Cant create ${servicesdir}/$revhostlookup-$portnumber.cfg\n";
		#print SERVICEFILE "define service {\n\tuse\t\t\t$servicepriority\n";
		#print SERVICEFILE "\thost_name\t\tcore1.gnmedia.net\n";
		#print SERVICEFILE "\tservice_description\ttcp-$portnumber\n";
		#print SERVICEFILE "\tservicegroups\t\ttcp-$portnumber\n";
		#print SERVICEFILE "\tcheck_command\t\t$check_command\n";
		#print SERVICEFILE "}\n";
		#close (SERVICEFILE);
		#print `cat ${servicesdir}/tcpports-$revhostlookup-$portnumber.cfg` if $debug;
#
        ## Instantiate service group lists
        #$servicegrouphash->{"tcp-$portnumber"} = 1;
	#}
}
print Dumper($iphash) if $debug;

create_dir($servicedepsdir,$autogenhead);
create_dir($serviceescalationdir,$autogenhead);

foreach my $site (keys(%$sitehash)) {
	my $hashh = $items->{$sitehash->{$site}->{"assetid"}};
	my $parenthost = $iphash->{$sitehash->{$site}->{"host_name"}}->{"naghostname"};
	if (!$parenthost) {next;}
	my $portlist = $hashh->{"MonitorPortNumber"};
	foreach my $portnumber (@$portlist) {
        my $servicegroupslist = "";
		my $check_command;
		my $check_options;
		if ($hashh->{"MonitorProtocol"} =~ /http/i) {
            $servicegroupslist .= $hashh->{"MonitorProtocol"} . ",";
			$check_command = "check_http";
            $check_options = "-H $site ";
			$check_options .= "-f follow ";
			$check_options .= "-p $portnumber ";
			if ($hashh->{"MonitorURLPath"}) {
				$check_options .= "-u \'" . $hashh->{"MonitorURLPath"} . "\' ";
			}
			if ($hashh->{"MonitorResultString"}) {
				$check_options .= "-s \'" . $hashh->{"MonitorResultString"} . "\' ";
			}
			if ($hashh->{"MonitorProtocol"} =~ /https/i) {
				$check_options .= "--ssl ";
			}
		} else {
			print "Skipping invalid protocol check ",$hashh->{"MonitorProtocol"},"\n";
			next;
		}
        if (my $busowner = $hashh->{"BusinessUnit"}) {
            $servicegroupslist .= join(',',@$busowner) .  ',';
            $servicegroupslist =~ s/\s+/_/g;
        }
		my $servicename = $site . " " . $hashh->{"MonitorProtocol"} . "-" . $portnumber;
        chop $servicegroupslist;
		open (SERVICEFILE, ">$servicesdir/checkhttp-$site-$portnumber.cfg") || die "Cant create $servicesdir/$site-$portnumber.cfg";
                print SERVICEFILE "# IP Addr: ",$sitehash->{$site}->{"host_name"},"\n";
		print SERVICEFILE "define service {\n";
		my $servicelevel = 'generic-service';
		if ($hashh->{"MonitorPriority"} =~ /(low|medium|high)/i) {
			$servicelevel = lc($hashh->{"MonitorPriority"}) . '-priority-service';
		}
                my $hostname="external";
                if ($sitehash->{$site}->{"host_name"} =~ /^72.172.7/) {
                    $hostname="internal";
                }
		print SERVICEFILE "\tuse\t\t\t$servicelevel\n";
		print SERVICEFILE "\thost_name\t\t$hostname\n";
		print SERVICEFILE "\tservice_description\t$servicename\n";
		print SERVICEFILE "\tcheck_command\t\t$check_command!$check_options\n";
        print SERVICEFILE "\tservicegroups\t\t$servicegroupslist\n";
		print SERVICEFILE "}\n";
		close (SERVICEFILE);
		print `cat $servicesdir/site-$site-$portnumber.cfg` if $debug;

        foreach my $servicegroup (split(/,/,$servicegroupslist)) {
            if ($servicegroup) {
                $servicegrouphash->{$servicegroup} = 1;
            }
        }

		#open (SERVICEDEPSFILE,">$servicedepsdir/site-$site-$portnumber.cfg") || die "Cant create $servicedepsdir/$site-$portnumber.cfg";
		#print SERVICEDEPSFILE "define servicedependency {\n";
		#print SERVICEDEPSFILE "\thost_name\t\tcore1.gnmedia.net\n";
		#print SERVICEDEPSFILE "\tservice_description\ttcp-$portnumber\n";
		#print SERVICEDEPSFILE "\tdependent_host\t\tcore1.gnmedia.net\n";
		#print SERVICEDEPSFILE "\tdependent_service_description\t$servicename\n";
		#print SERVICEDEPSFILE "\tnotification_failure_criteria\tw,u,c,p\n";
		#print SERVICEDEPSFILE "\tinherits_parent\t\t1\n";
		#print SERVICEDEPSFILE "}\n";
		#close (SERVICEDEPSFILE);
		#print `cat $servicedepsdir/site-$site-$portnumber.cfg` if $debug;

		#if ($hashh->{"MonitorPriority"} =~ /high/i) {
			#open (SERVICEESCFILE, ">$serviceescalationdir/$site-$portnumber.cfg") || die "Cant create $serviceescalationdir/$site-$portnumber.cfg";
			#print SERVICEESCFILE "define serviceescalation {\n";
			#print SERVICEESCFILE "\t";
			#close (SERVICEDEPSFILE);
			#print `cat $serviceescalationdir/$site-$portnumber.cfg` if $debug;
		#}
	}
}
print Dumper($servicegrouphash) if $debug;

create_dir($servicegroupsdir,$autogenhead);

foreach my $servicegroup (keys(%$servicegrouphash)) {
    open (SERVICEGROUPFILE,">$servicegroupsdir/$servicegroup.cfg") || die "Cant create $servicegroupsdir/$servicegroup.cfg\n";
    print SERVICEGROUPFILE "define servicegroup {\n";
    print SERVICEGROUPFILE "\tservicegroup_name\t$servicegroup\n";
    print SERVICEGROUPFILE "\talias\t\t\t$servicegroup\n";
    print SERVICEGROUPFILE "}\n";
    close (SERVICEGROUPFILE);
    print `cat $servicegroupsdir/$servicegroup.cfg` if $debug;
}
