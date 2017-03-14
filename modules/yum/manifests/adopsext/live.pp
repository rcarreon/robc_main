class yum::adopsext::live ($enabled=1) inherits yum::client {
    file { '/etc/yum.repos.d/adopsext-live.repo':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['/etc/yum.repos.d'],
    }
    yumrepo {'adopsext-live':
        enabled  => $enabled,
        descr    => 'Adops extras live mirror repo',
        baseurl  => "http://yumoter.gnmedia.net/adopsext/$::lsbmajdistrelease/live/",
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/adopsext-live.repo'],
    }
}
