# Class httpd::base

class httpd::base inherits common::app {
    include monit::apache
    include collectd::plugins::apache
    include logrotate

    if $defaulthttpdlogging == false {
        $logcomm='#'
    } else {
        $logcomm=''
    }

    package { 'httpd':
        ensure => present,
    }

    service { 'httpd':
        ensure    => running,
        enable    => true,
        hasstatus => true,
        require   => Package['httpd'],
    }

    # If project spec file exist use it if not default httpd.conf
    file { '/etc/httpd/conf/httpd.conf':
        ensure    => file,
        source    => [
            "puppet:///modules/httpd/httpd-${httpd}.conf",
            "puppet:///modules/httpd/httpd-centos${::lsbmajdistrelease}.conf",
            'puppet:///modules/httpd/httpd.conf'
        ],
        require   => Package['httpd'],
        notify    => Service[httpd],
        owner     => 'root',
        group     => 'root',
        mode      => '0644',
    }

    file { 'httpd_shared_directory':
        ensure    => directory,
        path      => '/app/shared',
        owner     => 'root',
        group     => 'root',
        mode      => '0664',
        require   => Class['common::app'],
    }

    # /app/log must be writeable for apache group (we have some cron using that group)
    File['/app/log'] {
        owner     => apache,
        group     => apache,
        require   => Package[httpd],
    }


    # For load balancer health check
    file { '/var/www/html/index.html':
        content   => 'up',
        mode      => '0644',
        owner     => 'root',
        group     => 'root',
        require   => Package['httpd'],
    }
    # For specific health checks
    file { '/var/www/html/healthcheck.php':
        source    => 'puppet:///modules/httpd/healthcheck.php',
        mode      => '0644',
        owner     => 'root',
        group     => 'root',
        require   => Package['httpd'],
    }
    # For app to db mapping in vip visual
    file {'/etc/cron.hourly/app2db_connchk.sh':
        owner     => 'root',
        group     => 'root',
        mode      => '0755',
        source    => 'puppet:///modules/httpd/app2db_connchk.sh',
    }
    # Making sure, we can serve new types
    file { '/etc/httpd/conf.d/addtypes.conf':
        ensure    => file,
        source    => 'puppet:///modules/httpd/addtypes.conf',
        require   => Package['httpd'],
        notify    => Service[httpd],
        owner     => 'deploy',
        group     => 'deploy',
        mode      => '0644',
    }
    # Making sure, we have some caching for static files
    file { '/etc/httpd/conf.d/expires.conf':
        ensure    => file,
        source    => [
            "puppet:///modules/httpd/expires-${httpd}.conf",
            'puppet:///modules/httpd/expires.conf'
        ],
        require   => Package['httpd'],
        notify    => Service[httpd],
        owner     => 'deploy',
        group     => 'deploy',
        mode      => '0644',
    }
    # /server-status enabled but for localhost only
    file { '/etc/httpd/conf.d/status.conf':
        ensure    => file,
        source    => 'puppet:///modules/httpd/status.conf',
        require   => Package['httpd'],
        notify    => Service[httpd],
        owner     => 'deploy',
        group     => 'deploy',
        mode      => '0644',
    }

    # We don't need red hat crap
    file { '/etc/httpd/conf.d/welcome.conf':
        ensure    => absent,
        require   => Package['httpd'],
        notify    => Service[httpd],
    }

    # We don't need red hat crap
    file { '/etc/httpd/conf.d/proxy_ajp.conf':
        ensure    => absent,
        require   => Package['httpd'],
        notify    => Service[httpd],
    }
    # some useful info (hostname, time to generate the request)
    file { '/etc/httpd/conf.d/headers.conf':
        ensure    => file,
        content   => template('httpd/headers.conf.erb'),
        require   => Package['httpd'],
        notify    => Service[httpd],
        owner     => 'root',
        group     => 'root',
        mode      => '0644',
    }

    #  We compress text based files (css, js, html)
    file { '/etc/httpd/conf.d/deflates.conf':
        ensure    => file,
        source    => 'puppet:///modules/httpd/deflates.conf',
        require   => Package['httpd'],
        notify    => Service[httpd],
        owner     => 'deploy',
        group     => 'deploy',
        mode      => '0644',
    }

    #  We prevent browsing of .svn and other files/folders
    file { '/etc/httpd/conf.d/protected-access.conf':
        ensure    => file,
        source    => 'puppet:///modules/httpd/protected-access.conf',
        require   => Package['httpd'],
        notify    => Service[httpd],
        owner     => 'deploy',
        group     => 'deploy',
        mode      => '0644',
    }

    # Logrotate
    file { 'httpd_logrotate':
        ensure    => file,
        path      => '/etc/logrotate.d/httpd',
        owner     => 'root',
        group     => 'root',
        mode      => '0644',
        require   => Package['logrotate'],
        content   => template('httpd/logrotate.erb'),
    }

    # We need a default vhost, in case no `host` headers are sent by the visitor
    file { '/etc/httpd/conf.d/000-default.conf':
        content   => template('httpd/000-default.conf.erb'),
        require   => Package['httpd'],
        notify    => Service['httpd'],
        owner     => 'root',
        group     => 'root',
        mode      => '0644',
    }
}

