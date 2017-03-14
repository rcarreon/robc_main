node 'app1v-gweb.af.prd.lax.gnmedia.net' {
    include base
    $project="affluent"
    include common::app
    include httpd

    httpd::virtual_host{"af.gweb.gnmedia.net":}

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_af_lax_prd_app_log/app1v-gweb.af.prd.lax.gnmedia.net",
    }

    common::nfsmount { "/app/data/backup":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_af_lax_prd_app_gweb/gweb-data",
    }

}
