define subversion::websvn_conf {
    file {"/etc/web${name}":
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }
    file {"/etc/web${name}/config.php":
        content => template('subversion/websvn.config.php.erb'),
        require => File["/etc/web${name}"],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
}