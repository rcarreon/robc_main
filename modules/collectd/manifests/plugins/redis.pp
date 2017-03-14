class collectd::plugins::redis {
    include collectd::client
    package {'collectd-redis':
        ensure  => installed,
        require => Class['collectd::client'],
    }

    file {'/etc/collectd.d/redis.conf':
        source  => 'puppet:///modules/collectd/redis.conf',
        require => Package['collectd-redis'],
        notify  => Class['collectd::service'],
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }
}
