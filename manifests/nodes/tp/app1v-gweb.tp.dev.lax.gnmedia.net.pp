node 'app1v-gweb.tp.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="admin"
    include common::app
    include httpd

    httpd::virtual_host{"tpgweb.gnmedia.net":} 
    common::nfsmount { "/app/data/backup":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_app_gweb/gweb-data",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_app_log/app1v-gweb.tp.dev.lax.gnmedia.net",
    }
}
