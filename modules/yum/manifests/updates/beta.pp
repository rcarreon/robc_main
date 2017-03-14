class yum::updates::beta ($enabled=1) inherits yum::client {
    file { '/etc/yum.repos.d/updates-beta.repo':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['/etc/yum.repos.d'],
    }
    yumrepo {'updates-beta':
        enabled  => $enabled,
        descr    => 'Gorillanation\'s beta mirror of centos update repos',
        baseurl  => "http://yumoter.gnmedia.net/updates/$::lsbmajdistrelease/beta/",
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/updates-beta.repo'],
    }
}
