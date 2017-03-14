node 'app2v-sdvideos.ao.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="atomiconline"
    include common::app
    include httpd
    include php
    
    httpd::virtual_host { "sherdogvideos.com": expect => "refresh" }
    
    common::nfsmount { "/app/shared/docroots/sherdogvideos.com":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sdvideos_ao_lax_prd_app_shared/sherdogvideos.com",
    }
    
    common::nfsmount { "/app/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app2v-sdvideos.ao.prd.lax.gnmedia.net",
    }
}
