class crowdignite::app_ci_dev {

    ### Common pkgs
    include common::app
    include sysctl
    include subversion::client
    include php::browscap
    include logrotate::crowdignite_cakephp
    include yum::ius
    include php::ius
    include php::ius::memcached
    include php::ius::imagick
    include php::ius::redis

    # we want the updates-live mysql-libs
    package { ['mysqlclient16', 'mysql55-libs']:
        ensure => absent,
    }

    ### DEV only pkgs
    package { 'vim-enhanced':
      ensure => installed,
    }

    ### Dev vhost declaration
    httpd::virtual_host {'dev.crowdignite.com': monitor => false,}

    ### Common app conf
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
    file { ['/app/ugc']:
        ensure  => directory,
        owner   => apache,
        group   => deploy,
    }
    ### cronjobs cronspec for dev viewing
    file { ['/app/log/cronjobs', '/app/log/cronjobs/jobspec/']:
        ensure  => directory,
        owner   => apache,
        group   => apache,
        mode    => '0755',
    }

    # in case code is reverted or ugc symlink is deleted, put it back
    file { '/app/shared/public_html/app/webroot/img/upload':
        ensure => symlink,
        target => '/app/ugc',
        owner  => deploy,
        group  => deploy,
    }

    ### VW logging settings
    #moved to node manifest due to dynamic scoping changes in puppet 3.x
    #$script_path='crowdignite_engine'
    include cronjob
    cronjob::do_cron_dot_d_cron_file {'vwlogs.cron': }
    cronjob::do_cron_dot_d_script {'rotate_vwlogs.sh':}
    cronjob::do_cron_dot_d_script {'clean_data_share.sh':}

    file { ['/var/vw-log-ramdisk','/app/data/vwlogs', '/app/data/vwlogs/done']:
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
