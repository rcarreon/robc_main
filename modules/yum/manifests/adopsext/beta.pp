class yum::adopsext::beta ($enabled=1) inherits yum::client {
    file { '/etc/yum.repos.d/adopsext-beta.repo':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['/etc/yum.repos.d'],
    }
    yumrepo {'adopsext-beta':
        enabled  => $enabled,
        descr    => 'Adops extras beta mirror repo',
        baseurl  => "http://yumoter.gnmedia.net/adopsext/$::lsbmajdistrelease/beta/",
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/adopsext-beta.repo'],
    }
}
