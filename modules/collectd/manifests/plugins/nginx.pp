class collectd::plugins::nginx {
    include collectd::client
    package {'collectd-nginx':
        ensure    => installed,
        require   => Class['collectd::client'],
    }

    file {'/etc/collectd.d/nginx.conf':
        source  => 'puppet:///modules/collectd/nginx.conf',
        require => Package['collectd-nginx'],
        notify  => Class['collectd::service'],
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }
}
