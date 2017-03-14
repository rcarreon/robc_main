node 'app2v-vb-pf.ao.stg.lax.gnmedia.net.pp' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="vb"
}
