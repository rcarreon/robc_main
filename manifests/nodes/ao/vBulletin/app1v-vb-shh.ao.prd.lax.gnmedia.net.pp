node 'app1v-vb-shh.ao.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    $httpd="vb"
    $project="vb"

    include base
    include common::app
    include httpd
    include php::shh
    include subversion::client
    include sendmail::use_gateway

    httpd::virtual_host {"forums.superherohype.com":}

    package { [ "php-pecl-json" ]:
        ensure => installed,
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/shh-shared",
    }

    common::nfsmount { "/app/ugc":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_prd_app_ugc/vb-shh-ugc",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app1v-vb-shh.ao.prd.lax.gnmedia.net",
    }
}
