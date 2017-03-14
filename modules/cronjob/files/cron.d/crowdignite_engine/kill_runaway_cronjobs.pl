#!/usr/bin/perl -w
# if php job is running for longer than time_limit, kill it.
use Time::Local;

# get current time in seconds since epoch
$now = time();
$date=`date +%F-%H:%M:%S`;
chomp $date;
print "Starting kill_runaway_cronjobs.pl at $date\n";

# set time_limit to 12 hours = 43200 seconds
$time_limit = 43200;

chomp(@ps = `ps -eo pid,bsdstart,args | grep php | egrep -v '(grep|COMMAND)'`);

foreach (@ps) {
    my ($pid) = split(' ');
    if(-e "/proc/$pid") {
        my ($start_time) = (stat("/proc/$pid"))[9];
        $elapsed_time=($now - $start_time);
        print "PID: $_\n";
        print "  Elapsed time:  $elapsed_time\n";
        if($elapsed_time > $time_limit) {
            print "$date Killing PID: $_\n";
            `kill -9 $pid`;
        }
    }
}

print "Finished kill_runaway_cronjobs.pl\n\n";
