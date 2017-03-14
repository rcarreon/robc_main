node 'app1v-logstash.tp.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project = "admin"
    common::nfsmount { "/app/shared":
        device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_app_shared/logstash-shared",
    }

    class {"logstash":
        redis_servers => ["localhost"],
        template => "logstash-dev",
    }

    class {"elasticsearch::parameterized":
        es_cluster => "logstash-dev-dev",
        #es_nodetype => ["none"],
    }

    redis::store { "logstash": }

    # required for passenger cap deploy
    include git::client
}
