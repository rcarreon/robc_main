class yum::puppetdependencies::beta ($enabled=1) inherits yum::client {

    file { '/etc/yum.repos.d/puppetdependencies-beta.repo':
        ensure  => present,
        require => File['/etc/yum.repos.d'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    yumrepo { 'puppetdependencies-beta':
        descr    => 'Gorillanation\'s beta mirror of puppetdependencies repos',
        baseurl  => "http://yumoter.gnmedia.net/puppetdependencies/$lsbmajdistrelease/beta/",
        enabled  => $enabled,
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/puppetdependencies-beta.repo'],
    }
}
