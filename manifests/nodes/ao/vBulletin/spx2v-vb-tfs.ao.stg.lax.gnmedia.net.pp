node 'spx2v-vb-tfs.ao.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="atomiconline"
    sphinx::conf { 'stg-tfs': span => '12', }
}
