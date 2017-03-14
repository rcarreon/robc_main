class yum::jenkins::live ($enabled=1) inherits yum::client {

    file { '/etc/yum.repos.d/jenkins-live.repo':
        ensure  => present,
        require => File['/etc/yum.repos.d'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    yumrepo { 'jenkins-live':
        descr    => 'Gorillanation\'s live mirror of jenkins repos',
        baseurl  => "http://yumoter.gnmedia.net/jenkins/$lsbmajdistrelease/live/",
        enabled  => $enabled,
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/jenkins-live.repo'],
    }
}
