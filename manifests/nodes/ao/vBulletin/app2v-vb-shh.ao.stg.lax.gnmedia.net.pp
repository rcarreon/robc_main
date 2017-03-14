node 'app2v-vb-shh.ao.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $httpd="vbc6"
    $project="vb"

    include common::app
    include httpd
    include git::client
    include mysqld56::client
    include php::shh
    
    httpd::virtual_host {"forums.superherohype.com": monitor => false,}

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_shared/vb-shh-shared",
    }
    
    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_log/app2v-vb-shh.ao.stg.lax.gnmedia.net",
    }
    
    common::nfsmount { "/app/ugc":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_stg_app_ugc/vb-shh-ugc",
    }
}
