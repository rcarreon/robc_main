# Class: redis::monitor

class redis::monitor {

    include redis::install
    nagios::service {'redis':
        command   => 'check_redis',
        notes_url => 'http://docs.gnmedia.net/wiki/Nagios-check_redis'
    }
    include collectd::plugins::redis

}
