node 'app2v-wzf.ao.prd.lax.gnmedia.net' {
    include base
        $project="vb"                                                                                                                                                                                                
        include common::app
        httpd::virtual_host {"forums.wrestlezone.com":}
        include subversion::client
        include sendmail::use_gateway
        include php::wzf
        package { [ "php-pecl-json" ]:
                ensure => installed,
        }

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/wzf-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app2v-wzf.ao.prd.lax.gnmedia.net",
        }
}
