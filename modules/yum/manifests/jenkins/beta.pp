class yum::jenkins::beta ($enabled=1) inherits yum::client {

    file { '/etc/yum.repos.d/jenkins-beta.repo':
        ensure  => present,
        require => File['/etc/yum.repos.d'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    yumrepo { 'jenkins-beta':
        descr    => 'Gorillanation\'s beta mirror of jenkins repos',
        baseurl  => "http://yumoter.gnmedia.net/jenkins/$lsbmajdistrelease/beta/",
        enabled  => $enabled,
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/jenkins-beta.repo'],
    }
}
