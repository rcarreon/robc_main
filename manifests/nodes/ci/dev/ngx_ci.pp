class crowdignite::ngx_ci_dev {

    ### Common pkgs
    include sysctl
    include security
    include common::app
    include yum::ius
    include php::ius
    include php::ius::memcached
    include php::ius::imagick
    include php::ius::redis

    php::fpm {'nginx': pkgname => php54-fpm, }
    class {'nginx::install': config_template=>'default-non-proxy'}
    include php::browscap

    # we want the updates-live mysql-libs
    package { ['mysqlclient16', 'mysql55-libs']:
        ensure => absent,
    }

    ### DEV only pkgs
    package { 'vim-enhanced':
      ensure => installed,
    }

    ### Dev vhost declaration
    $env='stg'
    nginx::vhost {'dev.widget.crowdignite.com': virtual_template=>'widget.crowdignite.com',vhost_list=>'dev.widget.crowdignite.com '}

    nagios::service {'widgets_17_xml':
        command => "check_url_xml!dev.widget.crowdignite.com!http://${::fqdn}/widgets/17?content=xml!10!",
        notes_url => "http://docs.gnmedia.net/wiki/Nagios-check_url",
    }

    nagios::service {'widgets_36_xml2':
        command => "check_url_xml!dev.widget.crowdignite.com!http://${::fqdn}/widgets/36?content=xml2!10!",
        notes_url => "http://docs.gnmedia.net/wiki/Nagios-check_url",
    }

    nagios::service {'widgets_36_xml_live':
        command => "check_url_xml!dev.widget.crowdignite.com!http://${::fqdn}/widgets/36?content=xml_live!10!",
        notes_url => "http://docs.gnmedia.net/wiki/Nagios-check_url",
    }

    ### VW logging settings
    #moved to node manifest due to dynamic scoping changes in puppet 3.x
    #$script_path='crowdignite_engine'
    include cronjob
    cronjob::do_cron_dot_d_cron_file {'vwlogs.cron': }
    cronjob::do_cron_dot_d_script {'rotate_vwlogs.sh':}
    cronjob::do_cron_dot_d_script {'clean_data_share.sh':}

    file { ['/app/ugc']:
        ensure  => directory,
        owner   => apache,
        group   => deploy,
    }

    file { ['/var/vw-log-ramdisk','/app/data/vwlogs', '/app/data/vwlogs/done']:
        ensure  => directory,
        owner   => apache,
        group   => apache,
        mode    => '0755',
    }

    ### cronjobs cronspec for dev viewing
    file { ['/app/log/cronjobs', '/app/log/cronjobs/jobspec/']:
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
        options => 'size=256m',
    }


}