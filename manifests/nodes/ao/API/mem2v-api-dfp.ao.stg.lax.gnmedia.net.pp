node 'mem2v-api-dfp.ao.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
        include base
        $project="api-dfp"
        include memcached
}
