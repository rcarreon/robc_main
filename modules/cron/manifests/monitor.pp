# Monitoring

define cron::monitor ($warntime = '240', $crittime = '300', $ensure = 'present') {
    if ($warntime >= 180) {
        $minute = 0
    } elsif (180 > $warntime and $warntime >= 90) {
        $minute = [5,35]
    } elsif (90 > $warntime and $warntime  >= 60) {
        $minute = [16,36,56]
    } elsif (60 > $warntime and $warntime >= 30) {
        $minute = '*/10'
    } elsif (30 > $warntime and $warntime >= 15) {
        $minute = '*/5'
    } else {
        $minute = '*'
    }

    cron { "croncheck_$name":
        ensure    => $ensure,
        user      => nobody,
        command   => 'touch /tmp/croncheck.tmp',
        hour      => '*',
        minute    => $minute,
    }

    $warntimesecs = 60 * $warntime
    $crittimesecs = 60 * $crittime
    nagios::service {"cron_$name":
        ensure    => $ensure,
        command   => "check_nrpe_args!check_file_age!/tmp/croncheck.tmp!$warntimesecs!$crittimesecs",
        notes_url => 'http://docs.gnmedia.net/wiki/Nagios-croncheck'
    }
}
