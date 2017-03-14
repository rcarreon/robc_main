node 'app1v-phab.tp.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="admin"
    include common::app
    include httpd

    logrotate::rotate_logs_in_dir { 'phd':
        directory => '/app/log/phd',
    }

    httpd::virtual_host{"dev.phabricator.gnmedia.net": }

    package { ["git","php","php-mysql","php-pecl-apc","php-mbstring","php-gd","php-ldap","php-process","python-pygments"]:
        ensure => installed,
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_app_shared/phab-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1-int.tp.dev.lax.gnmedia.net:/vol/nac1a_tp_lax_dev_app_log/app1v-phab.tp.dev.lax.gnmedia.net",
    }
}
