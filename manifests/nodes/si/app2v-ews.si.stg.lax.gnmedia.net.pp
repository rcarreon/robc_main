node 'app2v-ews.si.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="si"
        include common::app
        include httpd
        include php
        include subversion::client
	include ews::commonconfig::stg

        httpd::virtual_host {"webservices.evolvemediacorp.com":}

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_si_lax_stg_app_shared/ews-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_si_lax_stg_app_log/app2v-ews.si.stg.lax.gnmedia.net",
        }
}
