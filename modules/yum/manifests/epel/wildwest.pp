class yum::epel::wildwest ($enabled=1) inherits yum::client {
    file { '/etc/yum.repos.d/epel-wildwest.repo':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['/etc/yum.repos.d'],
    }
    yumrepo {'epel-wildwest':
        enabled  => $enabled,
        descr    => 'Gorillanation\'s wildwest mirror of centos update repos',
        baseurl  => "http://yumoter.gnmedia.net/epel/$::lsbmajdistrelease/wildwest/",
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/epel-wildwest.repo'],
    }
}
