node 'app2v-assets.si.stg.lax.gnmedia.net' {
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
                options => "nfsvers=3,noatime,rw,rsize=32768,wsize=32768,hard,intr,tcp,context=system_u:object_r:httpd_sys_content_t:s0",
        }

        common::nfsmount { "/app/log":
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_si_lax_stg_app_log/app2v-assets.si.stg.lax.gnmedia.net",
                options => "nfsvers=3,noatime,rw,rsize=32768,wsize=32768,hard,intr,tcp,context=system_u:object_r:httpd_sys_content_t:s0",
        }
}
