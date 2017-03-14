node 'app2v-stats-cms.sbv.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    include cms::stats::prod
    $project="springboard"
    include ganglia::modules::sbv_stats
    include pythondeployer

    httpd::virtual_host {"analytics.springboardvideo.com":
        expect => "[OK] APPLICATION HEALTHCHECK",
        uri    => "/healthcheck.php",
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_prd_app_shared/stats_cms_shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sbv_lax_prd_app_log/app2v-stats-cms.sbv.prd.lax.gnmedia.net",
    }
}
