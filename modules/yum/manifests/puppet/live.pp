class yum::puppet::live ($enabled=1) inherits yum::client {

    file { '/etc/yum.repos.d/puppet-live.repo':
        ensure  => present,
        require => File['/etc/yum.repos.d'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    yumrepo { 'puppet-live':
        descr    => 'Gorillanation\'s live mirror of puppet repos',
        baseurl  => "http://yumoter.gnmedia.net/puppet/$lsbmajdistrelease/live/",
        enabled  => $enabled,
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/puppet-live.repo'],
    }
}
