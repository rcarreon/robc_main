# qt config rt vhost
define rt::config::rt_vhost($pass = 'secret', $server_alias = false, $db_host = 'localhost', $db_user = 'rt_user', $db_pass = 'rt_pass', $sso = false) {
    file{'/etc/rt3/RT_SiteConfig.pm':
        content => template('rt/RT_SiteConfig.pm.erb'),
        require => [ Package[httpd], Class['rt::install'] ],
        notify  => Service[httpd],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
    file{'/etc/httpd/conf.d/rt.conf':
        content => template('rt/rt.conf.erb'),
        require => Package[httpd],
        notify  => Service[httpd],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
    file{'/etc/rt3/AT_SiteConfig.pm':
        source  => 'puppet:///modules/rt/AT_SiteConfig.pm',
        require => [ Package[httpd], Class['rt::install'] ],
        notify  => Service[httpd],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
    file{'/etc/rt3/AT_Config.pm':
        ensure  => link,
        target  => '/usr/share/rt3/etc/AssetTracker/AT_Config.pm',
    }
}
