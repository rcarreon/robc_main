# Varnish Nagios monitoring

class varnish::monitor {
    # Nagios check FTW
    nagios::service {'varnish':
        command   => 'check_url!default!/!up',
        notes_url => 'http://docs.gnmedia.net/wiki/Nagios-varnish',
    }

    include collectd::plugins::varnish


}
