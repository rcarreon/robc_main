node 'app1v-api-cs.ao.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base

    $username="deploy"
    $project="api-cs"
    $httpd="api-cs"
    include ao::api::cs
    include ao::api::cs::prd_configs

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/api-cs-shared",
    }

    common::nfsmount { "/app/storage":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/api-cs-storage",
    }

    common::nfsmount { '/app/ugcapics':
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_prd_app_ugc/api-ugc/api.comingsoon.net",
    }    

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app1v-api-cs.ao.prd.lax.gnmedia.net",
    }
}
