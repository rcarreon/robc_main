node 'app1v-kibana.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="admin"
    include common::app
    include kibana::dashboards

    # passenger, woot
    #$passenger_version = "3.0.12"
    class { 'passenger::params':
        passenger_version => '3.0.12'
    }
    include passenger

    # required for passenger cap deploy
    include git::client
    package {["rubygem-bundler"]:
        ensure => present,
    }

    kibana::vhost { "dev.kibana.gnmedia.net":
        elasticsearch_servers => [
            "app300v-elasticsearch.tp.prd.lax.gnmedia.net:9200",
            "app301v-elasticsearch.tp.prd.lax.gnmedia.net:9200",
        ],
    }

    kibana::vhost { "stg.kibana.gnmedia.net":
        elasticsearch_servers => [
            "app200v-elasticsearch.tp.prd.lax.gnmedia.net:9200",
            "app201v-elasticsearch.tp.prd.lax.gnmedia.net:9200",
        ],
    }

    kibana::vhost { "prd.kibana.gnmedia.net":
        elasticsearch_servers => [
            "app100v-elasticsearch.tp.prd.lax.gnmedia.net:9200",
            "app101v-elasticsearch.tp.prd.lax.gnmedia.net:9200",
        ],
    }

}
