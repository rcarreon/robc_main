class collectd::config {
    # All the configuration files depend on the collectd package
    # and notify the collectd service
    File {
        require => Class['collectd::package'],
        notify  => Class['collectd::service'],
    }

    # Main collectd configuration
    file {'/etc/collectd.conf':
        content => template('collectd/collectd.conf.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    # typical unix plugins
    file {'/etc/collectd.d/cpu.conf':
        source  => 'puppet:///modules/collectd/cpu.conf',
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }
    file {'/etc/collectd.d/memory.conf':
        source  => 'puppet:///modules/collectd/memory.conf',
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }
    file {'/etc/collectd.d/swap.conf':
        source  => 'puppet:///modules/collectd/swap.conf',
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }
    file {'/etc/collectd.d/df.conf':
        content => template('collectd/df.conf.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
    file {'/etc/collectd.d/disk.conf':
        content => template('collectd/disk.conf.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
    file {'/etc/collectd.d/interface.conf':
        source  => 'puppet:///modules/collectd/interface.conf',
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }
    file {'/etc/collectd.d/processes.conf':
        source  => 'puppet:///modules/collectd/processes.conf',
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }
    file {'/etc/collectd.d/load.conf':
        source  => 'puppet:///modules/collectd/load.conf',
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }
    file {'/etc/collectd.d/nfs.conf':
        source  => 'puppet:///modules/collectd/nfs.conf',
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }
    file {'/etc/collectd.d/vmem.conf':
        source  => 'puppet:///modules/collectd/vmem.conf',
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }
}
