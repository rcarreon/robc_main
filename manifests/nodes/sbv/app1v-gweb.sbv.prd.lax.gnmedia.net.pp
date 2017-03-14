node 'app1v-gweb.sbv.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="springboard"
    include common::app
    include httpd
    include pythondeployer

    httpd::virtual_host {"sbv.gweb.gnmedia.net":}

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_prd_app_log/app1v-gweb.sbv.prd.lax.gnmedia.net",
    }

    common::nfsmount { "/app/data/backup":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_prd_app_gweb/gweb-data",
    }
}
