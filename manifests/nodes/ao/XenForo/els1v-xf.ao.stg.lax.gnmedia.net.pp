node 'els1v-xf.ao.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="atomiconline"
    include common::app

    common::nfsmount { "/app/shared":
        device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_elasticsearch_lax_stg_app_shared/els1v-xf.ao.stg.lax.gnmedia.net",
    }

    class {"elasticsearch::parameterized":
        es_cluster => "ao-xenforo-stg",
    }
}
