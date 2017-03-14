node 'app1v-mgmt.ci.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base

#    $project="crowdignite"
    $httpd='crowdignite'
    $project='crowdignite_engine'
#    $phpenv="dev"
    include common::app
    include sysctl

    include yum::ius
    include php::browscap
    include logrotate::crowdignite_cakephp
    include php::ius
    include php::ius::memcached
    include php::ius::imagick

    package { 'php54-mbstring':
              ensure => 'installed'
    }

    vowpalwabbit::failurelogcheck { '/app/log/vw_landing-page-error_log' : }
    vowpalwabbit::failurelogcheck { '/app/log/vw_widget-error_log': }

    # we want the updates-live mysql-libs
    package { ['mysqlclient16', 'mysql55-libs']:
        ensure => absent,
    }

    $env='stg'

    httpd::virtual_host {'dev.engine.crowdignite.com': monitor => false,}

    file {'/app/log/cake_memcached.log':
        owner   => apache,
        group   => apache,
        mode    => '0644',
        ensure  => file,
    }

    file {'/app/log/cakephp':
        ensure  => directory,
        owner   => apache,
        group   => apache,
        require => File['/app/log']
    }

    file { ['/app/ugc']:
        ensure  => directory,
        owner   => apache,
        group   => deploy,
    }

    common::nfsmount { '/app/shared':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_dev_app_shared/ci-shared',
    }

    common::nfsmount { '/app/log':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_dev_app_log/app1v-mgmt.ci.dev.lax.gnmedia.net',
    }

    # this is a shared vol btw dev and stg, don't panic, it is the correct vol :)
    common::nfsmount { '/app/ugc_old':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_stg_app_ugc/upload',
    }

    common::nfsmount { '/app/ugc':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_stg_app_ugc_tmp/upload',
    }

}
