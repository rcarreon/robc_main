node 'mem2v-vb.ao.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    $project="vb53"
    include base
    include memcached
    include sysctl
    include security
}
