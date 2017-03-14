node 'app201v-elasticsearch.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="admin"
    include common::app

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_elasticsearch_lax_prd_app_shared/app201v-elasticsearch.tp.prd.lax.gnmedia.net",
    }

    class {"elasticsearch::parameterized":
        es_cluster => "logstash-prd-stg",
    }
}
