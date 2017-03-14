class yum::puppetdependencies::live ($enabled=1) inherits yum::client {

    file { '/etc/yum.repos.d/puppetdependencies-live.repo':
        ensure  => present,
        require => File['/etc/yum.repos.d'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    yumrepo { 'puppetdependencies-live':
        descr    => 'Gorillanation\'s live mirror of puppetdependencies repos',
        baseurl  => "http://yumoter.gnmedia.net/puppetdependencies/$lsbmajdistrelease/live/",
        enabled  => $enabled,
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/puppetdependencies-live.repo'],
    }
}
