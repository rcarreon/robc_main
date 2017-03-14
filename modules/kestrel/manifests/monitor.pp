
class kestrel::monitor {

    nagios::service {"kestrel":
        command => "check_kestrel",
        notes_url => "http://docs.gnmedia.net/wiki/Nagios-check_kestrel",
    }

    nagios::service {"kestrel_stats":
        command   => "check_kestrel_stats",
        notes_url => "http://docs.gnmedia.net/wiki/Nagios-check_kestrel",
        action_url => "http://$fqdn:2223/stats.txt",
    }

    nagios::service {"kestrel_queue":
        command   => "check_kestrel_queue",
        notes_url => "http://docs.gnmedia.net/wiki/Nagios-check_kestrel",
    }
    
    include collectd::plugins::kestrel
}
