class collectd::package {
    include monit::collectd

    package {'collectd':
        ensure => 'latest',
        before => Class['monit::collectd'],
    }
}
