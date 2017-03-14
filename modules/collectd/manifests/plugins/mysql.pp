class collectd::plugins::mysql {
    include collectd::client
    package {'collectd-mysql':
        ensure  => installed,
        require => Class['collectd::client']
    }

    file {'/etc/collectd.d/mysql.conf':
        source  => 'puppet:///modules/collectd/mysql.conf',
        require => Package['collectd-mysql'],
        notify  => Class['collectd::service'],
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }
}
