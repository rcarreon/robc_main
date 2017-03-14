node 'mem1v-api-dfp.ao.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
        include base
        $project="api-dfp"
        include memcached
}
