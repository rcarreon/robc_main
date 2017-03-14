node 'uid2v-rscott.ap.dev.lax.gnmedia.net' {
    include base
    $project="adops"
    include common::app

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_uid_shared/rscott-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_dev_app_log/uid2v-rscott.ap.dev.lax.gnmedia.net",
    }
}
