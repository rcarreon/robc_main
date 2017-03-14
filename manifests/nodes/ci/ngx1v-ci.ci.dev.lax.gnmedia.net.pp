node 'ngx1v-ci.ci.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base

    $env='stg'
    $project='crowdignite'
    $service_type='nginx'
    $script_path='crowdignite_engine'
    include crowdignite::ngx_ci_dev

    common::nfsmount { '/app/shared':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_dev_app_shared/ci-shared',
    }

    common::nfsmount { '/app/log':
            device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_dev_app_log/ngx1v-ci.ci.dev.lax.gnmedia.net',
    }

    common::nfsmount { '/app/data':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_dev_app_data/ngx1v-ci.ci.dev.lax.gnmedia.net',
    }

    ### UGC
    # this is a shared vol btw dev and stg, don't panic, it is the correct vol :)
    common::nfsmount { '/app/ugc':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_stg_app_ugc_tmp/upload',
    }
}
