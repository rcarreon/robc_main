node 'app2v-gweb.og.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="origin"
    $httpd='origin'
    include common::app
    include httpd

    httpd::virtual_host{"og.gweb.gnmedia.net":}

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_prd_app_shared/gweb-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_prd_app_log/app2v-gweb.og.prd.lax.gnmedia.net",
    }

    common::nfsmount { "/app/data/backup":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_prd_app_gweb/gweb-data",
    }

}
