# nagios memcache_trend_evictions class
class nagios::memcache_trend_evictions {
    nagios::service {'trend_memcache_evictions':
        command   => "check_ganglia_trending!'http://gweb.gnmedia.net/graph.cgi?r=week&h=${::fqdn}&m=mc_evictions&vl=items&json=1'!percent!points!.15!.25",
        notes_url => 'http://docs.gnmedia.net/wiki/Nagios_check_memcache_evictions',
    }
}
