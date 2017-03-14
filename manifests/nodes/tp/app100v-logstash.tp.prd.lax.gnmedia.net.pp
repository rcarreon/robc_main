node 'app100v-logstash.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="admin"
    $logstash_cluster = "logstash-prd-prd"
    include common::app

    class {"logstash":
        redis_servers => ["rds100v-logstash.tp.prd.lax.gnmedia.net", "rds101v-logstash.tp.prd.lax.gnmedia.net"],
    }

    class {"elasticsearch::parameterized":
        es_cluster => "logstash-prd-prd",
        es_nodetype => ["none"],
    }
}
