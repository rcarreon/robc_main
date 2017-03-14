class collectd::plugins::varnish {
    include collectd::client
    package {'collectd-varnish':
        ensure  => installed,
        require => Class['collectd::client'],
    }

    file {'/etc/collectd.d/varnish.conf':
        source  => 'puppet:///modules/collectd/varnish.conf',
        require => Package['collectd-varnish'],
        notify  => Class['collectd::service'],
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }
}
