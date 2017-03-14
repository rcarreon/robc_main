node 'app2v-assets.si.prd.lax.gnmedia.net' {
    include base
        $project = "doublehelix"
        include common::app
	include doublehelix::assets_sites
        include newrelic       
        include newrelic::params
        include newrelic::sysmond
        include newrelic::nfsiostat

	httpd::virtual_host {"secureassets.gorillanation.com":}
    httpd::virtual_host {"secureassets.evolvemediallc.com":}

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_si_lax_prd_app_shared/assets-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_si_lax_prd_app_log/app2v-assets.si.prd.lax.gnmedia.net",
        }
	common::nfsmount { "/app/video":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_prd_app_shared/preroll-shared",
	
	}
}
