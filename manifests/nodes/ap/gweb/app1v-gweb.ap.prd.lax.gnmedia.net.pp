node 'app1v-gweb.ap.prd.lax.gnmedia.net' {
    include base
    $project="adops"
    include common::app
    include httpd

    httpd::virtual_host{"ap.gweb.gnmedia.net":}

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_log/app1v-gweb.ap.prd.lax.gnmedia.net",
    }

    common::nfsmount { "/app/data/backup":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_gweb/gweb-data",
    }

}
