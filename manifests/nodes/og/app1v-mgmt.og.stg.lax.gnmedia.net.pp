node 'app1v-mgmt.og.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="origin"
    $httpd='origin'
    include origin::app_origin
    httpd::virtual_host {'management.originplatform.com': monitor => false }
    httpd::virtual_host {'support.originplatform.com': monitor => false }

    include mysqld56::client

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_stg_app_shared/origin-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_stg_app_log/app1v-mgmt.og.stg.lax.gnmedia.net",
    }

    common::nfsmount { "/app/ugc":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_stg_app_ugc",
    }
}
