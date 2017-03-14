class yum::ius_legacy::live ($enabled=1) inherits yum::client {

    file { '/etc/yum.repos.d/ius-live.repo':
        ensure  => present,
        require => File['/etc/yum.repos.d'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    yumrepo {'ius-live':
        descr    => 'Gorillanation\'s live mirror of ius repos',
        baseurl  => "http://yum.gnmedia.net/live/ius/$lsbmajdistrelease/",
        enabled  => $enabled,
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/ius-live.repo'],
    }
}