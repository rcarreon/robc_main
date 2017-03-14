node 'app201v-logstash.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="admin"
    $logstash_cluster = "logstash-prd-stg"
    include common::app

    class {"logstash":
        redis_servers => ["rds200v-logstash.tp.prd.lax.gnmedia.net", "rds201v-logstash.tp.prd.lax.gnmedia.net"],
    }

    class {"elasticsearch::parameterized":
        es_cluster => "logstash-prd-stg",
        es_nodetype => ["none"],
    }
}
