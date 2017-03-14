node 'app4v-stats-cms.sbv.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="springboard"
        $httpd="sbv-stats"
        include ganglia::modules::sbv_stats
	include httpd
        include common::app
        include ganglia::modules::mod_sflow
        include pythondeployer

	include cms::stats::stage

        httpd::virtual_host {"analytics.stg.springboardvideo.com":
                expect => "[OK] APPLICATION HEALTHCHECK",
                uri    => "/healthcheck.php",
        }

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_stg_app_shared/stats-shared",
        }


        common::nfsmount { "/app/log":
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sbv_lax_stg_app_log/app4v-stats-cms.sbv.stg.lax.gnmedia.net",
        }
}
