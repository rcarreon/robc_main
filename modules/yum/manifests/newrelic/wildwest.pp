class yum::newrelic::wildwest ($enabled=1) inherits yum::client {
    file { '/etc/yum.repos.d/newrelic-wildwest.repo':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['/etc/yum.repos.d'],
    }
    yumrepo {'newrelic-wildwest':
        enabled  => $enabled,
        descr    => 'Gorillanation\'s wildwest mirror of new relic',
        baseurl  => "http://yumoter.gnmedia.net/newrelic/$::lsbmajdistrelease/wildwest/",
        gpgcheck => 0,
        require  => File['/etc/yum.repos.d/newrelic-wildwest.repo'],
    }
}
