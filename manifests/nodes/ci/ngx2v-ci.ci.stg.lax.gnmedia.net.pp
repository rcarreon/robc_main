node 'ngx2v-ci.ci.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base

    $env='stg'
    $project='crowdignite'
    $service_type='nginx'
    $script_path='crowdignite_engine'
    include crowdignite::ngx_ci_stg

    common::nfsmount { '/app/shared':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_stg_app_shared/ci-shared',
    }

    common::nfsmount { '/app/log':
        device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ci_lax_stg_app_log/ngx2v-ci.ci.stg.lax.gnmedia.net',
    }

    common::nfsmount { '/app/data':
        device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ci_lax_stg_app_data/ngx2v-ci.ci.stg.lax.gnmedia.net',
    }

    common::nfsmount { '/app/ugc':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_stg_app_ugc_tmp/upload',
    }
}
