node 'app2v-ci.ci.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base

    $env='stg'
    $httpd='crowdignite'
    $project='crowdignite'
    $script_path='crowdignite_engine'
    include crowdignite::app_ci_stg
    include yum::ius

    package { 'php54-mbstring':
              ensure => 'installed'
    }

    common::nfsmount { '/app/shared':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_stg_app_shared/ci-shared',
    }

    common::nfsmount { '/app/log':
        device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ci_lax_stg_app_log/app2v-ci.ci.stg.lax.gnmedia.net',
    }

    # this is a separated tmp directory for cakephp
    common::nfsmount { '/app/tmp':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_stg_app_shared/app_ci_tmp',
    }

    common::nfsmount { '/app/data':
        device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ci_lax_stg_app_data/app2v-ci.ci.stg.lax.gnmedia.net',
    }

    common::nfsmount { '/app/ugc':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_stg_app_ugc_tmp/upload',
    }
}
