class yum::adopsext::wildwest ($enabled=1) inherits yum::client {
    file { '/etc/yum.repos.d/adopsext-wildwest.repo':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['/etc/yum.repos.d'],
    }
    yumrepo {'adopsext-wildwest':
        enabled  => $enabled,
        descr    => 'Adops extras wildwest mirror repo',
        baseurl  => "http://yumoter.gnmedia.net/adopsext/$::lsbmajdistrelease/wildwest/",
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/adopsext-wildwest.repo'],
    }
}
