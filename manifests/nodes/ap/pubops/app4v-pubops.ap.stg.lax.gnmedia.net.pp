node 'app4v-pubops.ap.stg.lax.gnmedia.net' {
    include base
    $project="adops"

    include ap::app::pubops
    include ap::app::pubops::stg

    httpd::virtual_host {"stg.pubops.evolvemediacorp.com": monitor => false}

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_stg_app_shared/pubops-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_stg_app_log/app4v-pubops.ap.stg.lax.gnmedia.net",
    }

    common::nfsromount { "/app/software":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_stg_app_shared/ap-software-stg",
    }

}
