class yum::puppetdependencies::wildwest ($enabled=1) inherits yum::client {

    file { '/etc/yum.repos.d/puppetdependencies-wildwest.repo':
        ensure  => present,
        require => File['/etc/yum.repos.d'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    yumrepo { 'puppetdependencies-wildwest':
        descr    => 'Gorillanation\'s wildwest mirror of puppetdependencies repos',
        baseurl  => "http://yumoter.gnmedia.net/puppetdependencies/$lsbmajdistrelease/wildwest/",
        enabled  => $enabled,
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/puppetdependencies-wildwest.repo'],
    }
}
