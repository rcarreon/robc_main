
node 'kes1v-ci.ci.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project='crowdignite'
    $kestrelenv='dev'
    include common::app
    include sysctl
    include security
    include kestrel

    package { 'vim-enhanced':
        ensure => installed,
    }

    common::nfsmount { '/app/shared':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_dev_mem_kestrel/kes1v-ci.ci.dev.lax.gnmedia.net',
    }

    common::nfsmount { '/app/log':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_dev_mem_log/kes1v-ci.ci.dev.lax.gnmedia.net',
    }

}
