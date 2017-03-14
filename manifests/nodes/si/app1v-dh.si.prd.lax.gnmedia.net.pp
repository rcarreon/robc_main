node 'app1v-dh.si.prd.lax.gnmedia.net' {
    include base
        $project = "doublehelix"
        include common::app
        include doublehelix::fe_sites
	include doublehelix::commonconfig::prd
	include newrelic 
	include newrelic::params 
	include newrelic::sysmond 
	include newrelic::nfsiostat 
        #include audit
        #include doublehelix::nodejs


        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_si_lax_prd_app_shared/dh-shared",
                options => "nfsvers=3,noatime,rw,rsize=32768,wsize=32768,hard,intr,tcp,context=system_u:object_r:httpd_sys_content_t:s0",
        }

        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_si_lax_prd_app_log/app1v-dh.si.prd.lax.gnmedia.net",
                options => "nfsvers=3,noatime,rw,rsize=32768,wsize=32768,hard,intr,tcp,context=system_u:object_r:httpd_sys_content_t:s0",
        }
        common::nfsmount { "/app/tmp":
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_si_lax_prd_app_tmp/app1v-dh.si.prd.lax.gnmedia.net",
                options => "nfsvers=3,noatime,rw,rsize=32768,wsize=32768,hard,intr,tcp,context=system_u:object_r:httpd_sys_content_t:s0",
        }
        common::nfsmount { "/app/ugc":
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_si_lax_prd_app_ugc/dh-ugc",
                options => "nfsvers=3,noatime,rw,rsize=32768,wsize=32768,hard,intr,tcp,context=system_u:object_r:httpd_sys_content_t:s0",
        }

}
