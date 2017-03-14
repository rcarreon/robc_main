node 'spx1v-vb-tfs.ao.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="atomiconline"
    sphinx::conf { 'stg-tfs': span => '5', }

    cron { "delta-reindex":
        command => "/usr/bin/indexer --rotate postdelta threaddelta >/dev/null 2>&1",
        user    => sphinx,
        minute  => "*/5",
    }
}
