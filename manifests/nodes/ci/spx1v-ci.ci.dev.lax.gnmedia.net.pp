node 'spx1v-ci.ci.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project='crowdignite'

    class { 'sphinxrt': sphinx_version => '2.2.4-1.rhel6' }

    include common::app

    common::nfsmount { '/app/shared':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_dev_spx_shared/ci-shared',
    }

    common::nfsmount { '/app/log':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_dev_spx_log/spx1v-ci.ci.dev.lax.gnmedia.net',
    }
}
