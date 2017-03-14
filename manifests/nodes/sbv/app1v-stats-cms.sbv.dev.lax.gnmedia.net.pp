node 'app1v-stats-cms.sbv.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="springboard"
        include common::app
	include cms::stats::dev
	include subversion::client
        include pythondeployer
#        include admin::ipv6_disable

	httpd::virtual_host {"dev.analytics.gorillanation.com":}

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_dev_app_shared/stats-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_dev_app_log/app1v-stats-cms.sbv.dev.lax.gnmedia.net",
        }
}
