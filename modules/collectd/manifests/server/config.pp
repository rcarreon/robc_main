class collectd::server::config inherits collectd::config {
    include collectd::server::packages
    file {'/etc/collectd.d/server.conf':
        content => template('collectd/server.conf.erb'),
        require => Class['collectd::server::packages'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
}
