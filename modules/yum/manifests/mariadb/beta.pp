class yum::mariadb::beta ($enabled=1) inherits yum::client {
    file { '/etc/yum.repos.d/mariadb-beta.repo':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['/etc/yum.repos.d'],
    }
    yumrepo {'mariadb-beta':
        enabled  => $enabled,
        descr    => 'Gorillanation\'s beta mirror of mariadb',
        baseurl  => "http://yumoter.gnmedia.net/mariadb/$::lsbmajdistrelease/beta/",
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/mariadb-beta.repo'],
    }
}
