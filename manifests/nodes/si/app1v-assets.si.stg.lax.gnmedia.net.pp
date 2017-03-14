node 'app1v-assets.si.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project = "doublehelix"
        include common::app
	include doublehelix::assets_sites


        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_si_lax_stg_app_shared/assets-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_si_lax_stg_app_log/app1v-assets.si.stg.lax.gnmedia.net",
        }
}
