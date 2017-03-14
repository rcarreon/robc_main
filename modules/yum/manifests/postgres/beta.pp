class yum::postgres::beta ($enabled=1) inherits yum::client {

    file { '/etc/yum.repos.d/postgres-beta.repo':
        ensure  => present,
        require => File['/etc/yum.repos.d'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    yumrepo { 'postgres-beta':
        descr    => 'Gorillanation\'s beta mirror of postgres repos',
        baseurl  => "http://yumoter.gnmedia.net/postgres/$lsbmajdistrelease/beta/",
        enabled  => $enabled,
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/postgres-beta.repo'],
    }
}
