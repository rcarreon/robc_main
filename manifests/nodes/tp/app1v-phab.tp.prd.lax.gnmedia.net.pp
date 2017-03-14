node 'app1v-phab.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project='admin'
    $phabrwpass=decrypt('yNRXyV8t6zotxxmfBHx/UQ==')
    include common::app
    include httpd
    include php::timezone
    include php::apcstatdisable

    httpd::virtual_host{'phabricator.gnmedia.net': }

    package { ['git','php','php-mysql','php-pecl-apc','php-mbstring','php-gd','php-ldap','php-process','python-pygments']:
        ensure => installed,
    }

    common::nfsmount { '/app/shared':
        device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_tp_lax_prd_app_shared/phab-shared',
    }

    common::nfsmount { '/app/log':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_log/app1v-phab.tp.prd.lax.gnmedia.net',
    }

    file { '/app/shared/docroots/phabricator.gnmedia.net/phabricator/conf/local/local.json':
        owner   => 'deploy',
        group   => 'deploy',
        content => template('common/phabricator/local.json.erb'),
    }

    file { '/app/log/phd':
        ensure => directory,
        owner  => 'apache',
        group  => 'apache',
        mode   => '0755',
    }

    logrotate::rotate_logs_in_dir { 'phd':
        directory => '/app/log/phd',
    }

    file { '/var/run/phd':
        ensure => directory,
        owner  => 'apache',
        group  => 'apache',
        mode   => '0755',
    }

    file { '/etc/php.d/max_size.ini':
        ensure => file,
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        source => 'puppet:///modules/php/phab_max_size.ini',
    }

}
