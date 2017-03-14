class crowdignite::app_ci_uid {

    file { "/etc/httpd/conf.d/${fqdn_type}.sbx.crowdignite.com.conf":
        ensure =>   absent,
        notify =>   Service['httpd'],
    }

    include puppet_agent::uid
    include security
    include memcached
    include common::app
    include sysctl
    include subversion::client
    include php::browscap
    include logrotate::crowdignite_cakephp
    include yum::ius
    include php::ius
    include php::ius::memcached
    include php::ius::redis
    include php::ius::imagick
    include php::ius::xdebug

    # we want the updates-live mysql-libs
    package { ['mysqlclient16', 'mysql55-libs']:
        ensure => absent,
    }

    ### DEV only pkgs
    package { ['vim-enhanced', 'java-1.6.0-openjdk.x86_64', 'ant', 'php54-devel', 'git',
               'php-phpunit-PHPUnit','php54-pdepend-PHP-Depend','php-phpunit-phploc',
               'php-phpmd-PHP-PMD','php-phpunit-phpcpd','php-pear-PHP-CodeSniffer']:
      ensure => installed,
    }

    # vw pkgs
    package { ['boost-program-options', 'vowpal-wabbit']:
        ensure => installed,
    }

    file {'/etc/php.d/xdebug.ini':
      ensure  => file,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('php/crowdignite/crowdignite_xdebug.ini.erb'),
    }

    ### cronjobs cronspec for dev viewing
    file { ['/app/log/cronjobs', '/app/log/cronjobs/jobspec/']:
        ensure  => directory,
        owner   => apache,
        group   => apache,
        mode    => '0755',
    }

    ### Common app conf
    httpd::virtual_host {'uid.sbx.crowdignite.com': monitor => false,}
    file {'/app/log/cake_memcached.log':
        owner   => apache,
        group   => apache,
        mode    => '0666',
        ensure  => file,
        require => File['/app/log'],
    }

    file {'/app/log/cakephp':
        ensure  => directory,
        owner   => apache,
        group   => apache,
        require => File['/app/log'],
    }

    # /app/tmp is local, but requires directories to be pre-populated
    file { ['/app/tmp','/app/tmp/cache','/app/tmp/cache/models','/app/tmp/cache/views','/app/tmp/cache/persistent']:
        ensure => directory,
        owner  => apache,
        group  => apache,
        mode   => '0775',
    }

    file {"/app/shared/${fqdn_type}":
        ensure  => directory,
        owner   => $fqdn_type,
        group   => $fqdn_type,
        require => File['/app/shared']
    }

    file { "/app/shared/${fqdn_type}/public_html/app/webroot/ccss":
        mode  => '0775',
        owner => $fqdn_type,
        group => apache,
    }

    file { "/app/shared/${fqdn_type}/public_html/app/webroot/cjs":
        mode  => '0775',
        owner => $fqdn_type,
        group => apache,
    }

#    # in case code is reverted or ugc symlink is deleted, put it back
#    file { "/app/shared/$fqdn_type/public_html/app/webroot/img/upload":
#        ensure => symlink,
#        target => '/app/ugc',
#        owner  => $fqdn_type,
#        group  => $fqdn_type,
#    }


    ### VW logging settings
    #moved to node manifest due to dynamic scoping changes in puppet 3.x
    #$script_path='crowdignite_engine'
    include cronjob
    cronjob::do_cron_dot_d_cron_file {'vwlogs.cron': }
    cronjob::do_cron_dot_d_script {'rotate_vwlogs.sh':}

    file { ['/var/vw-log-ramdisk','/app/log/vwlogs']:
        ensure  => directory,
        owner   => apache,
        group   => apache,
        mode    => '0755',
    }

    exec { 'mkmountpoint-var-vw-log-ramdisk':
        command => 'mkdir -p /var/vw-log-ramdisk',
        cwd     => '/',
        before  => Mount['/var/vw-log-ramdisk'],
        unless  => '/usr/bin/test -d /var/vw-log-ramdisk'
    }

    mount { '/var/vw-log-ramdisk':
        ensure  => mounted,
        device  => 'tmpfs',
        fstype  => 'tmpfs',
        options => 'size=128m',
    }
}
