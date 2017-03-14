node 'ngx1v-ci.ci.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project='crowdignite'
    $service_type='nginx'
    $script_path='crowdignite_engine'
    include crowdignite::ngx_ci_prd

    common::nfsmount { '/app/shared':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_prd_app_shared/ci-shared',
    }

    common::nfsmount { '/app/log':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_prd_app_log/ngx1v-ci.ci.prd.lax.gnmedia.net',
    }

    common::nfsmount { '/app/data':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_prd_app_data/ngx1v-ci.ci.prd.lax.gnmedia.net',
    }
}
