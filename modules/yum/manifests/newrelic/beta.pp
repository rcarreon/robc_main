class yum::newrelic::beta ($enabled=1) inherits yum::client {
    file { '/etc/yum.repos.d/newrelic-beta.repo':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['/etc/yum.repos.d'],
    }
    yumrepo {'newrelic-beta':
        enabled  => $enabled,
        descr    => 'Gorillanation\'s beta mirror of new relic',
        baseurl  => "http://yumoter.gnmedia.net/newrelic/$::lsbmajdistrelease/beta/",
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/newrelic-beta.repo'],
    }
}
