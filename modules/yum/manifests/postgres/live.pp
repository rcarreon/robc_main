class yum::postgres::live ($enabled=1) inherits yum::client {

    file { '/etc/yum.repos.d/postgres-live.repo':
        ensure  => present,
        require => File['/etc/yum.repos.d'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    yumrepo { 'postgres-live':
        descr    => 'Gorillanation\'s live mirror of postgres repos',
        baseurl  => "http://yumoter.gnmedia.net/postgres/$lsbmajdistrelease/live/",
        enabled  => $enabled,
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/postgres-live.repo'],
    }
}
