node 'app1v-gweb.ao.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="atomiconline"
    include common::app
    include httpd

    httpd::virtual_host{"ao.gweb.gnmedia.net":}

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app1v-gweb.ao.prd.lax.gnmedia.net",
    }
    common::nfsmount { "/app/data/backup":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_gweb/gweb-data",
    }
}
