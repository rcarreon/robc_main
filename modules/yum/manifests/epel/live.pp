class yum::epel::live ($enabled=1) inherits yum::client {
    file { '/etc/yum.repos.d/epel-live.repo':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['/etc/yum.repos.d'],
    }
    yumrepo {'epel-live':
        enabled  => $enabled,
        descr    => 'Gorillanation\'s live mirror of centos update repos',
        baseurl  => "http://yumoter.gnmedia.net/epel/$::lsbmajdistrelease/live/",
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/epel-live.repo'],
    }
}
