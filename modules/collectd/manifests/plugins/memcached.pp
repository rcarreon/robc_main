class collectd::plugins::memcached {
    include collectd::client
    file {'/etc/collectd.d/memcache.conf':
        source  => 'puppet:///modules/collectd/memcache.conf',
        require => Class['collectd::client'],
        notify  => Class['collectd::service'],
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }
}
