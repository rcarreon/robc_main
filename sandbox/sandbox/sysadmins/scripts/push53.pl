#!/usr/bin/perl -w

use strict;    
use DNS::ZoneParse;
use Data::Dumper;
use WebService::Amazon::Route53;
use File::Basename;
use Getopt::Std;

my %options=();
getopts("tdv", \%options);
my $SENDTOROUTE53 = 1;
if ($options{t}) {
    print "***************************************************\n";
    print "*** Test mode set, not pushing anything to route53!\n";
    print "***************************************************\n";
    $SENDTOROUTE53 = 0;
}
my $verbose = 0;
if ($options{v}) {
    $verbose = 1;
}

use constant AWS_ID => 'AKIAJKZPO45Y4YPYZPKQ';
use constant AWS_SECRET => '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';
# set ALERT_EMAIL to FALSE to disable email alerts.
use constant ALERT_EMAIL => 'q_la@evolvemediallc.com';
use constant INFO_EMAIL => 'q_cm@evolvemediallc.com';


my $newHost = $ARGV[0];
if (not defined $newHost) {
  die "Usage:\n\t$0 <ZONEFILE> (optional -t runs in test mode and will not push to route53)\n";
}

my $zone = $ARGV[0];
$zone =~ s{\.[^.]+$}{};
unless (-f $newHost) {
    print "[ERROR] ${newHost} file does not exist!\n";
    exit 1;
}

my $myTime=time();
my $tmpXml="/tmp/.tmpZone_${myTime}.xml";
my $tmpHost="/tmp/.tmpZone_${myTime}.host";
my $origin= basename($zone) . ".";
$zone = basename($zone);

# lets check if the zone exists on r53.
my $r53 = WebService::Amazon::Route53->new(id => AWS_ID, key => AWS_SECRET);
my $myzone = $r53->find_hosted_zone(name => $origin);
if (!$myzone) {
    print "[" . localtime() . "] $origin does not exist on route53...creating it.\n" if $verbose;
    my $response = $r53->create_hosted_zone(name => $origin, caller_reference => "${origin}new_${myTime}" );
    if (!$response) {
        # something went wrong zone wasn't created
        my $msg = "Zone $origin creation failedon route53!" . Dumper($response) . "\n";
        send_email($msg,'[ERROR] Zone creation failed!', ALERT_EMAIL);
	print "[ERROR] Zone creation failed!" . Dumper($response) . "\n";
	exit 1;
    }
    
    my $msg = "Created the following $zone on route53.\nThe following NS servers were assigned:\n" . Dumper($response->{delegation_set}{name_servers});;
    send_email($msg,'[DNSINFO] $zone created@route53', INFO_EMAIL);
}

#
# we can write this next part ourselves with the API, 
# but for now we will use already made tool from amazon.
#
open(my $fh, ">", "$ENV{HOME}/.boto") or die "Couldn't create .boto config: $!";
print $fh "[Credentials]
aws_access_key_id = " . AWS_ID . "
aws_secret_access_key = " . AWS_SECRET;
close ($fh);

my $r53_out = `/usr/local/bin/r53.py --zone ${zone} --pull > ${tmpXml}`;
my $tobind_out = `/usr/local/bin/route53tobind.pl --origin=${origin} < ${tmpXml} > ${tmpHost}`;
unlink "$ENV{HOME}/.boto";

unless (-e $tmpXml || -z $tmpXml) {
 print "[ERROR] tmp XML File Doesn't Exist or is Empty!";
 exit 1;
 } 

unless (-e $tmpHost || -z $tmpHost) {
 print "[ERROR] tmp Hosts File Doesn't Exist or is Empty!";
 exit 1;
 } 

my ($hashA,$hashB) = {};
# collect all the different parts of the zone file
# all but soa return name,host,class,ttl
# actually mx,srv,txt return slightly different results =p
# soa returns ('serial', 'origin', 'primary', 'refresh', 'retry', 'ttl', 'minimumTTL', 'email', 'expire')
# a(), cname(), mx(), ns(), ptr(), txt(), srv() ....soa()    
    my $zonefile = DNS::ZoneParse->new($tmpHost,$origin);
    $hashA->{'CNAME'} = $zonefile->cname();
    $hashA->{'A'} = $zonefile->a();
    $hashA->{'MX'} = $zonefile->mx();
    $hashA->{'PTR'} = $zonefile->ptr();
    $hashA->{'SOA'} = $zonefile->soa();
    $hashA->{'TXT'} = $zonefile->txt();
    $hashA->{'SRV'} = $zonefile->srv();

    $zonefile = DNS::ZoneParse->new($newHost,$origin);
    $hashB->{'CNAME'} = $zonefile->cname();
    $hashB->{'A'} = $zonefile->a();
    $hashB->{'MX'} = $zonefile->mx();
    $hashB->{'PTR'} = $zonefile->ptr();
    $hashB->{'SOA'} = $zonefile->soa();
    $hashB->{'TXT'} = $zonefile->txt();
    $hashB->{'SRV'} = $zonefile->srv();

# cleanup files
unlink($tmpXml);
unlink($tmpHost);

print "[" . localtime() . "] Starting on $origin\n";

print "*** Route53 Serial: $hashA->{'SOA'}{'serial'} ---- Local Serial: $hashB->{'SOA'}{'serial'}\n";

my ($tmp1,$tmp2) = {};
# now lets do some stuff!
for (keys %$hashA) {
#    print "Working on $_...\n" if $verbose;
    $tmp1={};
    $tmp2={};
    if ($_ eq 'SOA') {
	# reformat soa 
	my $aname = $hashA->{'SOA'}{'origin'};
	my $bname = $hashB->{'SOA'}{'origin'};

	$tmp1->{$aname}{'ttl'} = $hashA->{'SOA'}{'ttl'};
	$tmp2->{$bname}{'ttl'} = $hashB->{'SOA'}{'ttl'};

	$tmp1->{$aname}{'host'}="'$hashA->{'SOA'}{'primary'} $hashA->{'SOA'}{'email'} $hashA->{'SOA'}{'serial'} $hashA->{'SOA'}{'refresh'} $hashA->{'SOA'}{'retry'} $hashA->{'SOA'}{'expire'} $hashA->{'SOA'}{'minimumTTL'}'";
	$tmp2->{$bname}{'host'}="'$hashA->{'SOA'}{'primary'} $hashA->{'SOA'}{'email'} $hashB->{'SOA'}{'serial'} $hashB->{'SOA'}{'refresh'} $hashB->{'SOA'}{'retry'} $hashB->{'SOA'}{'expire'} $hashB->{'SOA'}{'minimumTTL'}'";

    } else {
        $tmp1 = to_hash($hashA->{$_}, $origin, $_, 'A');
        $tmp2 = to_hash($hashB->{$_}, $origin, $_, 'B');
    }

    diff_hash($tmp1, $tmp2, $origin, $_);
}

##################################################
##################################################

sub to_hash {
   my $tmp_arr = shift;
   my $origin = shift;
   my $type = shift;
   my $whatHash = shift;
   my $tmp_hash;

    if ($type eq 'MX') {
        @$tmp_arr =  sort { $a->{priority} <=> $b->{priority} } @$tmp_arr;
    }

    if ($type eq 'TXT') {
        @$tmp_arr =  sort { $a->{text} cmp $b->{text} } @$tmp_arr;
    } else {
        @$tmp_arr =  sort { $a->{host} cmp $b->{host} } @$tmp_arr;    
    }

   my ($name,$ttl,$host);
    
    foreach my $record (@$tmp_arr) {
        if ($record->{'host'}) {
            if ($record->{'host'} eq '127.0.0.1') {
    	        next;
            }
        }
        $name = lc($record->{name});
        if (($type ne 'A') 
           && ($type ne 'TXT')
           && ($whatHash eq 'B')
           && (substr($record->{'host'}, -1) ne '.')) {
                $record->{'host'} = $record->{'host'} . "." . $origin;
        }
	if (index($name, $origin) == -1) {
		$name="${name}.${origin}";
	}
        if ($type eq 'MX') {
	   $host = "'$record->{'priority'} $record->{'host'}'";
	} elsif ($type eq 'SRV') {
	   $host = "'$record->{'priority'} $record->{'weight'} $record->{'port'} $record->{'host'}'";
	} elsif ($type eq 'TXT') {
	   $host = "'\"$record->{'text'}\"'";
        } else {
	    $host = "'$record->{host}'";
        }
        $host=lc($host);
	$ttl = $record->{ttl};
        if (exists $tmp_hash->{$name}{host}) {
            $tmp_hash->{$name}{host}.=", ${host}";
	}else{
            $tmp_hash->{$name}{host}="${host}";
        }
	$tmp_hash->{$name}{ttl}=$ttl;
    }
 return $tmp_hash;
}

sub diff_hash {
    my $ahash = shift;
    my $bhash = shift;
    my $origin = shift;
    my $type = shift;

    my $tmp_changes='';
    my $r53 = WebService::Amazon::Route53->new(id => AWS_ID, key => AWS_SECRET);
    my $myzone = $r53->find_hosted_zone(name => $origin);
    my $count = 0;

for ( keys %{$bhash} ) {
    if ($count >= 250) {
        sendto_route53($tmp_changes, $r53, $myzone);
        $count = 0;
        $tmp_changes = '';
    }
    unless ( exists $ahash->{$_} ) {
        print "[" . localtime() . "] [UPSERT](${type}) $_ | $bhash->{$_}{'host'}\n" if $verbose;
        $count++;
        $tmp_changes .= "{
            action => 'upsert',
            name => '${_}',
            type => '${type}',
            ttl => $bhash->{$_}{'ttl'},\n";
        if ($bhash->{$_}{'host'} =~ /,/) {
            $tmp_changes .= "\t\trecords => [ $bhash->{$_}{'host'} ] },";
	} else {
	    $tmp_changes .= "\t\tvalue => $bhash->{$_}{'host'} },";
        }
        next;
    }
    if ( $bhash->{$_}{'host'} ne $ahash->{$_}{'host'} ) {
        print "[" . localtime() . "] [UPSERT] (${type}) $_ | $bhash->{$_}{'host'}\n" if $verbose;
        $count++;
        $tmp_changes .= "{
            action => 'upsert',
            name => '${_}',
            type => '${type}',
            ttl => $bhash->{$_}{'ttl'},\n";
        if ($bhash->{$_}{'host'} =~ /,/) {
            $tmp_changes .= "\t\trecords => [ $bhash->{$_}{'host'} ] },";
	} else {    
            $tmp_changes .= "\t\tvalue => $bhash->{$_}{'host'} },";
       }
    }
}

for ( keys %{$ahash} ) {
    unless ( exists $bhash->{$_} ) {
    if ($count >= 500) {
        sendto_route53($tmp_changes, $r53, $myzone);
        $count = 0;
        $tmp_changes = '';
    }
        print "[" . localtime() . "] [DELETE] (${type}) $_ | $ahash->{$_}{'host'}\n" if $verbose;
        $count++;
        $tmp_changes .= "{
            action => 'delete',
            name => '${_}',
            type => '${type}',
            ttl => $ahash->{$_}{'ttl'},\n";
        if ($ahash->{$_}{'host'} =~ /,/) {
            $tmp_changes .= "\t\trecords => [ $ahash->{$_}{'host'} ] },";
	} else {    
            $tmp_changes .= "\t\tvalue => $ahash->{$_}{'host'} },";
       }
        next;
    }
  }

    sendto_route53($tmp_changes, $r53, $myzone);
}

sub sendto_route53 {
 my $tmp_changes = shift;
 my $r53 = shift;
 my $myzone = shift;

 if ($tmp_changes ne "" && $SENDTOROUTE53 eq 1) {
     print "[" . localtime() . "] **** Pushing changes to Router53...\n" if $verbose;
     $tmp_changes = "[${tmp_changes}]";
     my $ref = eval $tmp_changes;
     my $change_return;

     $r53->change_resource_record_sets(zone_id => $myzone->{id}, changes => $ref );
     print "[" . localtime() . "] Done with $origin.\n";
     my $error = $r53->error;
     if ($error->{'code'}) {
        my $msg = "[ERROR] pushing to route53:\n" . Dumper($error) . "\n\n\nChanges sent:\n" . $tmp_changes . "\n";
        print "[ERROR] pushing to route53:\n" . Dumper($error) . "\n";
        send_email($msg,'[DNSERROR] Error pushing to route53!',ALERT_EMAIL);
     }
 }
}

sub send_email {
        my $msg = shift;
	my $subject = shift;
	my $email_to = shift;
        if ($email_to) {
            my $from = 'push53@gorillanation.com';
            open(MAIL, "|/usr/sbin/sendmail -t");
 
            # Email Header
            print MAIL "To: " . $email_to . "\n";
            print MAIL "From: $from\n";
            print MAIL "Subject: $subject\n\n";
            # Email Body
            print MAIL $msg; 
            close(MAIL);
            print "Email Sent Successfully\n" if $verbose;
        }
}    
