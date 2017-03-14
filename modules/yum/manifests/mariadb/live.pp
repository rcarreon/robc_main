class yum::mariadb::live ($enabled=1) inherits yum::client {
    file { '/etc/yum.repos.d/mariadb-live.repo':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['/etc/yum.repos.d'],
    }
    yumrepo {'mariadb-live':
        enabled  => $enabled,
        descr    => 'Gorillanation\'s live mirror of mariadb',
        baseurl  => "http://yumoter.gnmedia.net/mariadb/$::lsbmajdistrelease/live/",
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/mariadb-live.repo'],
    }
}
