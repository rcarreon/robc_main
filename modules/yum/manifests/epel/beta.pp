class yum::epel::beta ($enabled=1) inherits yum::client {
    file { '/etc/yum.repos.d/epel-beta.repo':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['/etc/yum.repos.d'],
    }
    yumrepo {'epel-beta':
        enabled  => $enabled,
        descr    => 'Gorillanation\'s beta mirror of centos update repos',
        baseurl  => "http://yumoter.gnmedia.net/epel/$::lsbmajdistrelease/beta/",
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/epel-beta.repo'],
    }
}
