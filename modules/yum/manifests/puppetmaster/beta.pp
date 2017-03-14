class yum::puppetmaster::beta ($enabled=1) inherits yum::client {

    file { '/etc/yum.repos.d/puppetmaster-beta.repo':
        ensure  => present,
        require => File['/etc/yum.repos.d'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    yumrepo { 'puppetmaster-beta':
        descr    => 'Gorillanation\'s beta mirror of puppetmaster repos',
        baseurl  => "http://yumoter.gnmedia.net/puppetmaster/$lsbmajdistrelease/beta/",
        enabled  => $enabled,
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/puppetmaster-beta.repo'],
    }
}
