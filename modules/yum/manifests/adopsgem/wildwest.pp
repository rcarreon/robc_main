class yum::adopsgem::wildwest ($enabled=1) inherits yum::client {
    file { '/etc/yum.repos.d/adopsgem-wildwest.repo':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['/etc/yum.repos.d'],
    }
    yumrepo {'adopsgem-wildwest':
        enabled  => $enabled,
        descr    => 'Adops ruby gems wildwest mirror repo',
        baseurl  => "http://yumoter.gnmedia.net/adopsgem/$::lsbmajdistrelease/wildwest/",
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/adopsgem-wildwest.repo'],
    }
}
