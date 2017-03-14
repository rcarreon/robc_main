class yum::puppet::wildwest ($enabled=1) inherits yum::client {

    file { '/etc/yum.repos.d/puppet-wildwest.repo':
        ensure  => present,
        require => File['/etc/yum.repos.d'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    yumrepo { 'puppet-wildwest':
        descr    => 'Gorillanation\'s wildwest mirror of puppet repos',
        baseurl  => "http://yumoter.gnmedia.net/puppet/$lsbmajdistrelease/wildwest/",
        enabled  => $enabled,
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/puppet-wildwest.repo'],
    }
}
