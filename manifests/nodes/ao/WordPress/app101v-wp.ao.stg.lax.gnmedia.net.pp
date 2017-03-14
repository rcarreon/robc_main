node 'app101v-wp.ao.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    include wordpresspb::appserver
    include ganglia::modules::mod_sflow
    $project="atomiconline"
    $httpd="pbwordpress"

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_shared/wp-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_log/app101v-wp.ao.stg.lax.gnmedia.net",
    }

    common::ugcmount { "/app/ugc":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_shared/wp-ugc",
    }
}
