node 'kes6v-ci.ci.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project='crowdignite'
    $kestrelenv='prd'
    include common::app
    include sysctl
    include security
    include kestrel
    include ganglia::modules::kestrel

    common::nfsmount { '/app/shared':
      device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ci_lax_prd_mem_kestrel/kes6v-ci.ci.prd.lax.gnmedia.net',
    }

    common::nfsmount { '/app/log':
        device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ci_lax_prd_mem_log/kes6v-ci.ci.prd.lax.gnmedia.net',
    }
}
