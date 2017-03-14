node 'els3v-xf.ao.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="atomiconline"
    include common::app

    common::nfsmount { "/app/shared":
        device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_elasticsearch_lax_prd_app_shared/els3v-xf.ao.prd.lax.gnmedia.net",
    }

    class {"elasticsearch::parameterized":
        es_cluster => "ao-xenforo-prd",
    }
}
