class yum::newrelic::live ($enabled=1) inherits yum::client {
    file { '/etc/yum.repos.d/newrelic-live.repo':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['/etc/yum.repos.d'],
    }
    yumrepo {'newrelic-live':
        enabled  => $enabled,
        descr    => 'Gorillanation\'s live mirror of new relic',
        baseurl  => "http://yumoter.gnmedia.net/newrelic/$::lsbmajdistrelease/live/",
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/newrelic-live.repo'],
    }
}
