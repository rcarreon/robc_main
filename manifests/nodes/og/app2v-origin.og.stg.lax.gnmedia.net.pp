node 'app2v-origin.og.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="origin"
    $httpd='origin'
    include origin::app_origin
    httpd::virtual_host {'stg.originplatform.com': monitor => false }
    httpd::virtual_host {'stg.metrics.originplatform.com': monitor => false }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_stg_app_shared/origin-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_og_lax_stg_app_log/app2v-origin.og.stg.lax.gnmedia.net",
    }

   common::nfsmount { "/app/ugc":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_stg_app_ugc",
    }

}
