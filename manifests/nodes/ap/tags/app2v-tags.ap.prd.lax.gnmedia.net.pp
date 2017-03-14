node 'app2v-tags.ap.prd.lax.gnmedia.net' {
    include base
    include ap::app::tags
    include ap::app::tags::prd

    include pipestash

    $project='adops'
    httpd::virtual_host {"prd.tags.evolvemediallc.com": monitor => false}

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_shared/tags-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_prd_app_log/app2v-tags.ap.prd.lax.gnmedia.net",
    }
}
