node 'app1v-vw.ci.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base

    $project='crowdignite_engine'
    include common::app
    include crowdignite::vw_ci_dev

    $script_path='crowdignite_engine'
    include cronjob
    cronjob::do_cron_dot_d_script {'reload_vw.sh':}

    common::nfsmount { '/app/shared':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_dev_app_shared/ci-shared',
    }

    common::nfsmount { '/app/log':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_dev_app_log/app1v-vw.ci.dev.lax.gnmedia.net',
    }

    common::nfsmount { '/app/data':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_dev_app_data/app1v-vw.ci.dev.lax.gnmedia.net',
    }

    common::nfsmount { '/app/data/vwmodels':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_dev_app_vwmodels/app1v-vw.ci.dev.lax.gnmedia.net',
    }

    common::nfsmount { '/app/data/vwmodels.live':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_dev_app_vwmodels/live',
    }

}
