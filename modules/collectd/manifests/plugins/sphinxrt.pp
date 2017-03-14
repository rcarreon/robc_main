class collectd::plugins::sphinxrt {
    include collectd::client

    file {'/etc/collectd.d/sphinxrt.conf':
        source  => 'puppet:///modules/collectd/sphinxrt.conf',
        notify  => Class['collectd::service'],
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }
}
