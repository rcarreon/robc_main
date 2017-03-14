node 'app1v-preroll.sbv.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="springboard"
        $at_silo = ''
        include common::app
	include httpd
        include pythondeployer

	httpd::virtual_host {"video.gorillanation.com": expect => "video",}

	file { "/app/video":
		ensure => "link",
		target => "/app/shared",
	}

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_prd_app_shared/preroll-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_prd_app_log/app1v-preroll.sbv.prd.lax.gnmedia.net",
        }
}
