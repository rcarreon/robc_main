class collectd::client::config inherits collectd::config {
    file {'/etc/collect.d/client.conf':
        ensure => absent,
    }

    file {'/etc/collectd.d/carbon_writer.conf':
        source => 'puppet:///modules/collectd/carbon_writer.conf',
        owner  => 'deploy',
        group  => 'deploy',
        mode   => '0644',
    }

    file {'/etc/collectd.d/carbon_writer.py':
        source => 'puppet:///modules/collectd/carbon_writer.py',
        owner  => 'deploy',
        group  => 'deploy',
        mode   => '0644',
    }

    if ($::lsbmajdistrelease == 6) {
        # on centos6, collectd can't load carbon_writer without this
        file {'/etc/default/collectd':
            ensure  => file,
            content => 'export LD_PRELOAD=/usr/lib64/libpython2.6.so.1.0',
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
        }
    }

    tidy { '/etc/collectd.d/server.conf':
        age    => '0s',
        backup => false,
    }
}
