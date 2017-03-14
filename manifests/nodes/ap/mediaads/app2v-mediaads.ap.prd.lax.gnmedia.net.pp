node 'app2v-mediaads.ap.prd.lax.gnmedia.net' {
    include base
    $project='adops'
    include common::app
    include httpd
    include php::ap_mediaads

    httpd::virtual_host{'mediaads.gorillanation.com': monitor => false }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_mediaads/mediaads-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_prd_app_log/app2v-mediaads.ap.prd.lax.gnmedia.net",
    }
}
