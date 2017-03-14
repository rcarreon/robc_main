node 'app1v-origin.og.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="origin"
    $httpd='origin'
    include origin::app_origin_dev
    httpd::virtual_host {'dev.originplatform.com': monitor => false }
    httpd::virtual_host {'metrics.originplatform.com': monitor => false }
    httpd::virtual_host {'edge.originplatform.com': monitor => false }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_dev_app_shared/origin-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_dev_app_log/app1v-origin.og.dev.lax.gnmedia.net",
    }

    common::nfsmount { "/app/ugc":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_dev_app_ugc",
    }

}
