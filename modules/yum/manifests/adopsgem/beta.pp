class yum::adopsgem::beta ($enabled=1) inherits yum::client {
    file { '/etc/yum.repos.d/adopsgem-beta.repo':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['/etc/yum.repos.d'],
    }
    yumrepo {'adopsgem-beta':
        enabled  => $enabled,
        descr    => 'Adops ruby gems beta mirror repo',
        baseurl  => "http://yumoter.gnmedia.net/adopsgem/$::lsbmajdistrelease/beta/",
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/adopsgem-beta.repo'],
    }
}
