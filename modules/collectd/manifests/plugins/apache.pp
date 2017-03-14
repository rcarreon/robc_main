class collectd::plugins::apache {
    include collectd::client
    package {'collectd-apache':
        ensure    => installed,
        require   => Class['collectd::client'],
    }

    file {'/etc/collectd.d/apache.conf':
        source  => 'puppet:///modules/collectd/apache.conf',
        require => Package['collectd-apache'],
        notify  => Class['collectd::service'],
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }
}
