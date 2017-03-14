class yum::ius_legacy::beta ($enabled=1) inherits yum::client {

    file { '/etc/yum.repos.d/ius-beta.repo':
        ensure  => present,
        require => File['/etc/yum.repos.d'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    yumrepo { 'ius-beta':
        descr    => 'Gorillanation\'s beta mirror of ius repos',
        baseurl  => "http://yum.gnmedia.net/beta/ius/$lsbmajdistrelease/",
        enabled  => $enabled,
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/ius-beta.repo'],
    }
}
