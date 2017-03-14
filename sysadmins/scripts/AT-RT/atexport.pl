#!/usr/bin/perl



# $ID$
use lib "./";
use strict;
use atsqlexport;
use Data::Dumper;
use Net::DNS;
use File::Path;
use MIME::Base64;
use Switch;



# Pingdom standard
my $sendtoandroid = "true";
my $sendtoemail = "true";
my $sendtoiphone = "true";
my $sendtosms = "false";
my $sendtotwitter = "true"; 

my $resolution = "1";
my $notifywhenbackup = "true";
my $notifyagainevery = "120";
my $sendnotificationwhendown = "2";

system "logger -t pingdom New run";

=from pingdom
Red (SA+CM+NOC) 189904
Garrick Staples 190225
Ali Argyle 189073
Roger Wang 190227
Dairenn Lombard 190228
=cut
my $defaultcontact = "189904,190225,189073,190227,190228";


my $requestheaders = '\"Cache-Control\": \"no-cache\",
                \"User-Agent\": \"Pingdom.com_bot_version_1.4_(http://www.pingdom.com/)\"';

my $debug=0;

# Use the first command line argument to turn off SMS messaging
if ( $ARGV[0] eq "off" ){
    $sendtosms = "false";
}

my $at = Infrastructure::AT->new( server => 'DBI:mysql:rt3:vip-sqlrw-inv.tp.prd.lax.gnmedia.net:3306', user => 'rtscripts_r', pass => decode_base64('Y25za2dSaUg='));

my $fields = [ 'Name', 'Status', 'MonitorPriority', 'MonitorProtocol', 'MonitorPortNumber', 'MonitorResultString', 'MonitorURLPath', 'BusinessOwner' ];
my $where = { Type => 'Site', Status => 'Production' };

my $items = $at->getAssets(fields => $fields, where => $where);
#print Dumper($items) if $debug;

foreach my $site (values(%$items)) {
 
    my $contacts = $defaultcontact;
    my $name;
    my $url;
    my $protocol;
    my $port;
    my $shouldcontain;
    my $priority;
    my $json_out;

	if (!($site->{"MonitorPriority"}) || $site->{"MonitorPriority"} =~ /off/i) {
		print "Skipping ", $site->{"Name"}, " MonitorPriority off\n" if $debug;
		next;
	}
	# Set the defaults for missing fields
	if (!$site->{"MonitorProtocol"}) {
		$items->{$site->{"id"}}->{"MonitorProtocol"} = "HTTP";
	}

	if (!$site->{"MonitorPortNumber"}) {
		$items->{$site->{"id"}}->{"MonitorPortNumber"} = ["80"];
		$site->{"MonitorPortNumber"} = ["80"];
	}

=from pingdom
Julien Rottenberg 189071
Jake Moilanen 189082
Reggie Collier 190231
Ryan Frank 190233
Windows Admins 190234
SpringobardPlatform 192143
Atomic Sites Hermosillo 192496
=cut
    if ($site->{"BusinessOwner"}) {
        foreach ($site->{"BusinessOwner"}) {
            switch ($_) {
                case "SheKnows"     {$contacts .= "";}
                case "Atomic Sites" {$contacts .= ",192496";}
                case "CrowdIgnite"  {$contacts .= ",189082";}
                case "PebbleBed"    {$contacts .= ",192143";}
                case "TechPlatform" {$contacts .= ",190234,190233,190231";}
                case "undef"        {print "";}
                else                {print "";}
            }
        }
    }

    #$contacts .= $contacts;
    $name = $site->{'Name'};
    $url = $site->{"MonitorURLPath"};
    $protocol = lc($site->{"MonitorProtocol"});
    $port = $site->{"MonitorPortNumber"}[0];
    $shouldcontain = $site->{"MonitorResultString"};
    $priority = $site->{"MonitorPriority"};

    $shouldcontain =  $site->{"MonitorResultString"};


    # Now that we have our data, display them
    $json_out = <<EOF;

{
    "sendtosms": "$sendtosms"
}
EOF

    $json_out =~ s/\s+//g;


    print "./pingdom-cli modify $name '$json_out'";
    system "./pingdom-cli modify $name '$json_out'";
    print "\n";

}

system "logger -t pingdom End of run";
print Dumper($items) if $debug;



