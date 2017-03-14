node 'app1v-dtapi.ao.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    $project="atomiconline"
    include base
    include httpd
    include rubygems
        httpd::virtual_host {"adopt.dogtime.com":}


        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_shared/dtapi-shared",
        }

        common::nfsmount { "/app/capistrano":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_shared/dtapi_capistrano",
        }

        common::nfsmount { "/app/log":
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_log/app1v-dtapi.ao.stg.lax.gnmedia.net",
        }

}
