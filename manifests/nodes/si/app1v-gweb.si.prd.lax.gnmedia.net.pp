node 'app1v-gweb.si.prd.lax.gnmedia.net' {
    include base
    $project="si"
    include common::app
    include httpd
    include newrelic       
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    
    httpd::virtual_host{"si.gweb.gnmedia.net":}

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_si_lax_prd_app_log/app1v-gweb.si.prd.lax.gnmedia.net",
    }

    common::nfsmount { "/app/data/backup":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_si_lax_prd_app_gweb/gweb-data",
    }
}
