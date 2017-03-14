node 'app1v-vw.ci.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base

    $project='crowdignite_engine'
    include common::app
    include crowdignite::vw_ci_stg

    $script_path='crowdignite_engine'
    include cronjob
    cronjob::do_cron_dot_d_cron_file {'vw.cron': }
    cronjob::do_cron_dot_d_script {'reload_vw.sh':}
    cronjob::do_cron_dot_d_script {'email_fatal_errors_stage.sh':}

    common::nfsmount { '/app/shared':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_stg_app_shared/ci-shared',
    }

    common::nfsmount { '/app/log':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_stg_app_log/app1v-vw.ci.stg.lax.gnmedia.net',
    }

    common::nfsmount { '/app/data':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_stg_app_data/app1v-vw.ci.stg.lax.gnmedia.net',
    }

    common::nfsmount { '/app/data/vwmodels':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_stg_app_vwmodels/app1v-vw.ci.stg.lax.gnmedia.net',
    }

    common::nfsmount { '/app/data/vwmodels.live':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_stg_app_vwmodels/live',
    }

    file { '/app/log/cronjobs/jobspec/vw.cron':
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => 'puppet:///modules/cronjob/cron.d/crowdignite_engine/vw.cron',
    }

    file { '/usr/local/bin/crowdignite_engine/conrun_vwWidget.sh':
        owner   => root,
        group   => root,
        mode    => '0755',
        content => template('cronjob/cron.d/crowdignite_engine/conrun_vwWidget.sh.erb'),
    }

    file { '/app/log/cronjobs/jobspec/conrun_vwWidget.sh':
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template('cronjob/cron.d/crowdignite_engine/conrun_vwWidget.sh.erb'),
    }

    file { '/usr/local/bin/crowdignite_engine/conrun_vwLanding.sh':
        owner   => root,
        group   => root,
        mode    => '0755',
        content => template('cronjob/cron.d/crowdignite_engine/conrun_vwLanding.sh.erb'),
    }

    file { '/app/log/cronjobs/jobspec/conrun_vwLanding.sh':
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template('cronjob/cron.d/crowdignite_engine/conrun_vwLanding.sh.erb'),
    }
}
