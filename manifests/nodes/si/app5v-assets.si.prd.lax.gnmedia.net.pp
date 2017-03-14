node 'app5v-assets.si.prd.lax.gnmedia.net' {
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
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_si_lax_prd_app_log/app5v-assets.si.prd.lax.gnmedia.net",
        }
}
