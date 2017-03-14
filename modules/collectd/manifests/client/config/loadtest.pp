class collectd::client::config::loadtest inherits collectd::client::config {
    File['/etc/collectd.conf'] {
        content => template('collectd/collectd_loadtest.conf.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
}
