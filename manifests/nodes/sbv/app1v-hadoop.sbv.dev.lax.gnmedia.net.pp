node 'app1v-hadoop.sbv.dev.lax.gnmedia.net' {
    include base
    $project="springboard"
    include common::app

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_dev_app_shared/hadoop-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_dev_app_log/app1v-hadoop.sbv.dev.lax.gnmedia.net",
    }
}
