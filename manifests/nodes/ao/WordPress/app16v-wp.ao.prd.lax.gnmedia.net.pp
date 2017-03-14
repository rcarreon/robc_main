node 'app16v-wp.ao.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        include wordpresspb::appserver
        include wordpresspb::pbwb_appprd_dbcred
    $project="atomiconline"
    $httpd="pbwordpress"
#        include ganglia::modules::mod_sflow

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/wp-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app16v-wp.ao.prd.lax.gnmedia.net",
        }

        common::ugcmount { "/app/ugc":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/wp-ugc",
        }

}
