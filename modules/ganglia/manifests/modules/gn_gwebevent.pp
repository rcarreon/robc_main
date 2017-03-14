class ganglia::modules::gn_gwebevent {
    file { '/usr/local/bin/gwebevent':
        ensure => present,
        mode   => '0755',
        owner  => 'root',
        group  => 'root',
        content => template("ganglia/modules/gwebevent.erb"),
    }
}
