node 'kes7v-ci.ci.prd.lax.gnmedia.net' {
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
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_prd_mem_kestrel/kes7v-ci.ci.prd.lax.gnmedia.net',
    }


    common::nfsmount { '/app/log':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_prd_mem_log/kes7v-ci.ci.prd.lax.gnmedia.net',
    }

}
