node 'app3v-atp.ao.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="atomiconline"
        $site="actiontrip"
	$httpd="actiontripc6"
        include subversion::client
        include common::app
        include php::atp
        include php::pecl_imagick
        include httpd
        httpd::virtual_host {"actiontrip.com":}
        httpd::virtual_host {"at-comics.com":}
        httpd::virtual_host {"www.origin.actiontrip.com":}

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/atp-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app3v-atp.ao.prd.lax.gnmedia.net",
        }

        common::nfsmount { "/app/ugc":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/atp-ugc",
        }
}
