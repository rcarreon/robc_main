node 'app3v-ci.ci.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $httpd='crowdignite'
    $project='crowdignite'
    $script_path='crowdignite_engine'
    include crowdignite::app_ci_prd
    include yum::ius

    package { 'php54-mbstring':
              ensure => 'installed'
    }

    common::nfsmount { '/app/shared':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_prd_app_shared/ci-shared',
    }

    common::nfsmount { '/app/log':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_prd_app_log/app3v-ci.ci.prd.lax.gnmedia.net',
    }
    common::nfsmount { '/app/tmp':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_prd_app_shared/app_ci_tmp',
    }

    common::nfsmount { '/app/data':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_prd_app_data/app3v-ci.ci.prd.lax.gnmedia.net',
    }
}
