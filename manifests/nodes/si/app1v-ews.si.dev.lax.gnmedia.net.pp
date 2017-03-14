node 'app1v-ews.si.dev.lax.gnmedia.net' {
    include base
        $project="si"
        include common::app
        include httpd
        include php
        include subversion::client
	include ews::commonconfig::dev
	include newrelic
	include newrelic::params
    	include newrelic::sysmond
    	include newrelic::nfsiostat

        httpd::virtual_host {"webservices.evolvemediacorp.com":}

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_si_lax_dev_app_shared/ews-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_si_lax_dev_app_log/app1v-ews.si.dev.lax.gnmedia.net",
        }
}
