node 'app1v-yourls.sbv.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="springboard"
    include common::app

    include httpd
    include php
    include ganglia::modules::mod_sflow
    include pythondeployer

    httpd::virtual_host {"stg.sbvid.us":
        uri => "/admin/",
    }

    # for cap deploys
    package { "subversion":
        ensure => installed,
    }


    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_stg_app_shared/yourls-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_stg_app_log/app1v-yourls.sbv.stg.lax.gnmedia.net",
    }
}
