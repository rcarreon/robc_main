node 'kes1v-ci.ci.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project='crowdignite'
    $kestrelenv='stg'
    include common::app
    include sysctl
    include security
    include kestrel
    include ganglia::modules::kestrel

    common::nfsmount { '/app/shared':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_stg_mem_kestrel/kes1v-ci.ci.stg.lax.gnmedia.net',
    }

    common::nfsmount { '/app/log':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_stg_mem_log/kes1v-ci.ci.stg.lax.gnmedia.net',
    }

}
