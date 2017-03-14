node 'app6v-stats-cms.sbv.stg.lax.gnmedia.net' {
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
        include audit
        include pythondeployer

	include cms::stats::stage

        httpd::virtual_host {"analytics.stg.springboardvideo.com":
                expect => "[OK] APPLICATION HEALTHCHECK",
                uri    => "/healthcheck.php",
        }

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_stg_app_shared/stats-shared",
                options => "nfsvers=3,noatime,rw,rsize=32768,wsize=32768,hard,intr,tcp,context=system_u:object_r:httpd_sys_content_t:s0",
        }


        common::nfsmount { "/app/log":
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sbv_lax_stg_app_log/app6v-stats-cms.sbv.stg.lax.gnmedia.net",
                options => "nfsvers=3,noatime,rw,rsize=32768,wsize=32768,hard,intr,tcp,context=system_u:object_r:httpd_sys_content_t:s0",
        }
}
