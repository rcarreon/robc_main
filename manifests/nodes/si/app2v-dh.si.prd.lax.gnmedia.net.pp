node 'app2v-dh.si.prd.lax.gnmedia.net' {
    include base
        $project = "doublehelix"
        include common::app
        include doublehelix::fe_sites
	include doublehelix::commonconfig::prd
        include audit
        include newrelic       
        include newrelic::params
        include newrelic::sysmond
        include newrelic::nfsiostat
        #include doublehelix::nodejs


        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_si_lax_prd_app_shared/dh-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_si_lax_prd_app_log/app2v-dh.si.prd.lax.gnmedia.net",
        }
        common::nfsmount { "/app/tmp":
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_si_lax_prd_app_tmp/app2v-dh.si.prd.lax.gnmedia.net",
        }
        common::nfsmount { "/app/ugc":
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_si_lax_prd_app_ugc/dh-ugc",
        }
}
