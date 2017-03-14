class yum::adopsgem::live ($enabled=1) inherits yum::client {
    file { '/etc/yum.repos.d/adopsgem-live.repo':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['/etc/yum.repos.d'],
    }
    yumrepo {'adopsgem-live':
        enabled  => $enabled,
        descr    => 'Adops ruby gems live mirror repo',
        baseurl  => "http://yumoter.gnmedia.net/adopsgem/$::lsbmajdistrelease/live/",
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/adopsgem-live.repo'],
    }
}
