#!/usr/bin/perl

use strict;

my $datadir="/tmp/.standupreg.d";
my $refresh=10;
my $ageout=15;

my %in=();
if (length ($ENV{'QUERY_STRING'}) > 0){
      my $buffer = $ENV{'QUERY_STRING'};
      my @pairs = split(/&/, $buffer);
      foreach my $pair (@pairs){
           my ($name, $value) = split(/=/, $pair);
           $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
           $in{$name} = $value; 
      }
 }


my $topic="";

if ($ENV{SERVER_NAME} =~ m/(.+)\.standup.evolvemediallc.com$/) {
    $topic=$1;
} else {
    $topic=$in{'topic'};
}

mkdir "$datadir";

if (exists $in{hangoutUrl}) {
    # We are being passed a hangouturl, best keep a record of it.
    if (defined $topic) {
        if ($topic eq "undefined") {
           print "Content-type: text/html\n\n";
           print "Topic is undefined, not registering.\n";
           exit(0);
        }
        open(REGOUT,">$datadir/$topic") or print "\n\ncan't open $datadir/$topic\n";
        print REGOUT $in{hangoutUrl},"\n";
        close (REGOUT);
        print "Content-type: text/html\n\n";
        print "Registered $topic.";
        exit(0);
    } else {
        print "Content-type: text/html\n\n";
        print "No topic. This is an error.\n";
    }

} else {
   # The hangout url is being requested.
   if (defined $topic) {
        my $mtime = (stat("$datadir/$topic"))[9];
        my $age=time() - $mtime;
        my $url=fetchurl($topic);
        if ($url eq "Creating." && $age < 60) {
            print "Content-type: text/html\n\n";
            print "<html><head>\n";
            print "<META HTTP-EQUIV=\"refresh\" CONTENT=\"$refresh\"></head>";
            print "<body><br>$topic - pending...\n</body></html>";
            exit (0);
        } else {
            if ($age > $ageout) {
                open(REGOUT,">$datadir/$topic") or print "\n\ncan't open $datadir/$topic\n";
                print REGOUT "Creating.";
                close(REGOUT);
                print "Location: https://plus.google.com/hangouts/_?gid=664634643141\&hangout_type=party\&gd=$topic\n\n";
                exit(0);
            } else {
                print "Location: $url\n\n";
                exit (0);
            }
        }
   } else {
        print "Content-type: text/html\n\n";
        print '<!doctype html>';
        print "<html>\n";
        print '<head><title>Standup Hangout Regifier</title>';
print '<style type="text/css">
<!--
input{
text-align:right;
}
-->
</style>';


        print '<META HTTP-EQUIV="refresh" CONTENT="$refresh">';
        print "\n</head>\n<body>\n";
        print "<h3>Standup Hangout Regifier</h3>\n";
        opendir ( DIR, "$datadir") || die "Error in opening dir\n";
        my @dirs=(readdir(DIR));
        closedir(DIR);
        foreach my $topic ( sort @dirs ){
            next if $topic =~ m/^\./;
            my $mtime = (stat("$datadir/$topic"))[9];
            my $age=time() - $mtime;
            my $url=fetchurl($topic);
            if ($url eq "Creating.") {
                if ($age > 60) {
                    #print "<br><a href=\"?topic=$topic\">$topic</a> - create timed out.\n";
                    print "<br><a href=\"http://$topic.standup.evolvemediallc.com/\">$topic.standup.evolvemediallc.com</a> - create timed out.\n";
                } else {
                    print "<br>$topic - pending\n";
                }
            } else {
                if ($url) {
                    #print "<br><a href=\"?topic=$topic\">$topic</a> - ($age seconds old\)\n";
                    print "<br><a href=\"http://$topic.standup.evolvemediallc.com/\">$topic.standup.evolvemediallc.com</a> - (",$age < 10 ? "Active" : "Inactive","\)\n";
                } else {
                    print "<br>No URL registered for $topic.\n";
                }
            }
        }
   }
}

print <<__EOF__;
<br>
<hr>
<form method="GET">
    <!-- first one 182316423247 -->
    <!-- second one 329670749644 -->
    <!-- third one 664634643141 -->
    <input type="hidden" name="gid" value="664634643141">
    <input type="hidden" name="hangout_type" value="party">
    Create a new hangout:<br> <input name="topic" value="foo">.standup.evolvemediallc.com
    <br><input type="submit">
</form>
<p><span style="font-style: italics; font-size: small"><a href="http://docs.gnmedia.net/wiki/Standup_Regifier">Standup Regifier</a></span>
</html>
__EOF__

#foreach my $foo (keys %ENV) {
   #print "<br>$foo".$ENV{$foo}."\n";
#}


sub fetchurl($) {
        open(REGOUT,"$datadir/$topic") or return;
        my $url=<REGOUT>;
        close (REGOUT);
        chomp($url);
        if ($url eq "Creating.") {
            return $url;
        } 
        return $url."?gid=664634643141\&gd=$topic\&topic=$topic";
}

sub displayseconds($) {
   my $secsi=shift;

   my $days=int($secsi/(24*60*60));
   my $hours=($secsi/(60*60))%24;
   my $mins=($secsi/60)%60;
   my $secs=$secsi%60;

   if ($days > 0) {
       return "$days days, $hours hours";
   } elsif ($hours > 0) {
       return "$hours hours, $mins minutes";
   } elsif ($mins > 0) {
       return "$mins mins, $secs secs";
   } else {
       return "$secsi seconds";
   }
       
} 
