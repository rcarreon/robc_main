class yum::puppet::beta ($enabled=1) inherits yum::client {

    file { '/etc/yum.repos.d/puppet-beta.repo':
        ensure  => present,
        require => File['/etc/yum.repos.d'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    yumrepo { 'puppet-beta':
        descr    => 'Gorillanation\'s beta mirror of puppet repos',
        baseurl  => "http://yumoter.gnmedia.net/puppet/$lsbmajdistrelease/beta/",
        enabled  => $enabled,
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/puppet-beta.repo'],
    }
}
