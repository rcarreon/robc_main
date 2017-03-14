class yum::ius_legacy::wildwest ($enabled=1) inherits yum::client {

    file { '/etc/yum.repos.d/ius-wildwest.repo':
        ensure  => present,
        require => File['/etc/yum.repos.d'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    yumrepo { 'ius-wildwest':
        descr    => 'Gorillanation\'s wildwest mirror of ius repos',
        baseurl  => "http://yum.gnmedia.net/wildwest/ius/$lsbmajdistrelease/",
        enabled  => $enabled,
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/ius-wildwest.repo'],
    }
}
