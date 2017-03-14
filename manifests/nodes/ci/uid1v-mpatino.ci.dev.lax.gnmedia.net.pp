node 'uid1v-mpatino.ci.dev.lax.gnmedia.net' {
    include base

    $env='uid'
    $phpenv='uid'
    $httpd='crowdignite'
    $project='crowdignite'
    $script_path='crowdignite_engine'
    include crowdignite::app_ci_uid
    include crowdignite::ngx_ci_uid

    common::nfsmount { '/app/shared':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_dev_uid_shared/mpatino-shared',
    }

    common::nfsmount { '/app/log':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_dev_uid_log/uid1v-mpatino.ci.dev.lax.gnmedia.net',
    }

    common::nfsmount { '/app/ugc':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_stg_app_ugc_tmp/upload',
    }
}
