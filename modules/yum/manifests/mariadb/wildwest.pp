class yum::mariadb::wildwest ($enabled=1) inherits yum::client {
    file { '/etc/yum.repos.d/mariadb-wildwest.repo':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['/etc/yum.repos.d'],
    }
    yumrepo {'mariadb-wildwest':
        enabled  => $enabled,
        descr    => 'Gorillanation\'s wildwest mirror of mariadb',
        baseurl  => "http://yumoter.gnmedia.net/mariadb/$::lsbmajdistrelease/wildwest/",
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/mariadb-wildwest.repo'],
    }
}
