class yum::gnrepo::beta ($enabled=1) inherits yum::client {
    file { '/etc/yum.repos.d/gnrepo-beta.repo':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['/etc/yum.repos.d'],
    }
    yumrepo {'gnrepo-beta':
        enabled  => $enabled,
        descr    => 'Gorillanation\'s beta mirror of centos update repos',
        baseurl  => "http://yumoter.gnmedia.net/gnrepo/$::lsbmajdistrelease/beta/",
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/gnrepo-beta.repo'],
    }
}
