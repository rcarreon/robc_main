class yum::puppetmaster::live ($enabled=1) inherits yum::client {

    file { '/etc/yum.repos.d/puppetmaster-live.repo':
        ensure  => present,
        require => File['/etc/yum.repos.d'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    yumrepo { 'puppetmaster-live':
        descr    => 'Gorillanation\'s live mirror of puppetmaster repos',
        baseurl  => "http://yumoter.gnmedia.net/puppetmaster/$lsbmajdistrelease/live/",
        enabled  => $enabled,
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/puppetmaster-live.repo'],
    }
}
