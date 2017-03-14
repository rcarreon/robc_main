node 'app1v-mgmt.ci.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base

    $httpd='crowdignite'
    $project='crowdignite_engine'
    include common::app
    include sysctl
    include ganglia::modules::mod_sflow

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

    httpd::virtual_host {'engine.crowdignite.com': monitor => false,}

    file {'/app/log/cake_memcached.log':
        owner   => apache,
        group   => apache,
        mode    => '0644',
        ensure  => file,
    }

    common::nfsmount { '/app/shared':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_prd_app_shared/ci-shared',
    }

    common::nfsmount { '/app/log':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_prd_app_log/app1v-mgmt.ci.prd.lax.gnmedia.net',
    }

    file {'/app/log/cakephp':
        ensure  => directory,
        owner   => apache,
        group   => apache,
        require => File['/app/log']
    }

    # this is a separated tmp directory for cakephp
    common::nfsmount { '/app/tmp':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_prd_app_shared/app_ci_tmp',
    }

    #common::nfsmount { '/app/ugc_old':
    #    device => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ci_lax_prd_app_ugc/upload',
    #}
    common::nfsmount { '/app/ugc':
        device => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ci_lax_prd_app_ugc_tmp/upload'
    }

}
