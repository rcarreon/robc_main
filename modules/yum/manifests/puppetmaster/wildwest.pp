class yum::puppetmaster::wildwest ($enabled=1) inherits yum::client {

    file { '/etc/yum.repos.d/puppetmaster-wildwest.repo':
        ensure  => present,
        require => File['/etc/yum.repos.d'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    yumrepo { 'puppetmaster-wildwest':
        descr    => 'Gorillanation\'s wildwest mirror of puppetmaster repos',
        baseurl  => "http://yumoter.gnmedia.net/puppetmaster/$lsbmajdistrelease/wildwest/",
        enabled  => $enabled,
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/puppetmaster-wildwest.repo'],
    }
}
