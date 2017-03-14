class yum::jenkins::wildwest ($enabled=1) inherits yum::client {

    file { '/etc/yum.repos.d/jenkins-wildwest.repo':
        ensure  => present,
        require => File['/etc/yum.repos.d'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    yumrepo { 'jenkins-wildwest':
        descr    => 'Gorillanation\'s wildwest mirror of jenkins repos',
        baseurl  => "http://yumoter.gnmedia.net/jenkins/$lsbmajdistrelease/wildwest/",
        enabled  => $enabled,
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/jenkins-wildwest.repo'],
    }
}
