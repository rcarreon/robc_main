class collectd::plugins::kestrel {
    include collectd::client

    file {'/etc/collectd.d/kestrel.py':
        source  => 'puppet:///modules/collectd/kestrel.py',
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }

    file {'/etc/collectd.d/kestrel.conf':
        source  => 'puppet:///modules/collectd/kestrel.conf',
        require => File['/etc/collectd.d/kestrel.py'],
        notify  => Class['collectd::service'],
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }
}
