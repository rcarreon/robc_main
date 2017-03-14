class yum::gnrepo::wildwest ($enabled=1) inherits yum::client {
    file { '/etc/yum.repos.d/gnrepo-wildwest.repo':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['/etc/yum.repos.d'],
    }
    yumrepo {'gnrepo-wildwest':
        enabled  => $enabled,
        descr    => 'Gorillanation\'s wildwest mirror of centos update repos',
        baseurl  => "http://yumoter.gnmedia.net/gnrepo/$::lsbmajdistrelease/wildwest/",
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/gnrepo-wildwest.repo'],
    }
}
