node 'app6v-wp.ao.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    include wordpresspb::appserver
#    include ganglia::modules::mod_sflow
    $project="atomiconline"
    $httpd="pbwordpress"

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/wp-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app6v-wp.ao.prd.lax.gnmedia.net",
    }

    common::ugcmount { "/app/ugc":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/wp-ugc",
    }

}
