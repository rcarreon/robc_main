node 'app300v-logstash.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="admin"
    $logstash_cluster = "logstash-prd-dev"
    include common::app

    class {"logstash":
        redis_servers => ["rds300v-logstash.tp.prd.lax.gnmedia.net", "rds301v-logstash.tp.prd.lax.gnmedia.net"],
    }

    class {"elasticsearch::parameterized":
        es_cluster => "logstash-prd-dev",
        es_nodetype => ["none"],
    }
}
