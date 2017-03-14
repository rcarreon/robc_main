node 'app2v-vb-wz.ao.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="vb"

    include common::app
    include subversion::client
    include sendmail::use_gateway
    include php::wzf

    httpd::virtual_host { "forums.wrestlezone.com": monitor => false, }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/vb-wz-shared",
    }

    common::nfsmount { "/app/ugc":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_prd_app_ugc/vb-wz-ugc",
    }    

    common::nfsmount { "/app/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app2v-vb-wz.ao.prd.lax.gnmedia.net",
    }
}
