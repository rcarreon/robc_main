node 'app4v-origin.og.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="origin"
    $httpd='origin'
    include origin::app_origin
    include origin::app_shared
    httpd::virtual_host {'originplatform.com': }
    httpd::virtual_host {'metrics.originplatform.com': }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_prd_app_shared/origin-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_prd_app_log/app4v-origin.og.prd.lax.gnmedia.net",
    }

    common::nfsmount { "/app/ugc":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_prd_app_ugc",
    }

}
