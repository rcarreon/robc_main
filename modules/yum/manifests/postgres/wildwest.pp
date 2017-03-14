class yum::postgres::wildwest ($enabled=1) inherits yum::client {

    file { '/etc/yum.repos.d/postgres-wildwest.repo':
        ensure  => present,
        require => File['/etc/yum.repos.d'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    yumrepo { 'postgres-wildwest':
        descr    => 'Gorillanation\'s wildwest mirror of postgres repos',
        baseurl  => "http://yumoter.gnmedia.net/postgres/$lsbmajdistrelease/wildwest/",
        enabled  => $enabled,
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/postgres-wildwest.repo'],
    }
}
