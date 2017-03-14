node 'app1v-wzf.ao.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="vb"                                                                                                                                                                                                
        include common::app
        httpd::virtual_host {"forums.wrestlezone.com":}
        include subversion::client
        include php::wzf
        include sendmail::use_gateway

        package { [ "php-pecl-json" ]:
                ensure => installed,
        }

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/wzf-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app1v-wzf.ao.prd.lax.gnmedia.net",
        }
}
