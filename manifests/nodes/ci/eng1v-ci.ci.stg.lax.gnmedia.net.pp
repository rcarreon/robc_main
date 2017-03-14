node 'eng1v-ci.ci.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base

    $env='stg'
    $httpd='crowdignite'
    $project='crowdignite_engine'
    include crowdignite::eng_ci_stg

    $script_path='crowdignite_engine'
    include cronjob
    cronjob::do_cron_dot_d_cron_file {'eng1_stg.cron': }

    cronjob::do_cron_dot_d_script {'eng1_short.sh':}
    cronjob::do_cron_dot_d_script {'eng1_rebalance.sh':}
    cronjob::do_cron_dot_d_script {'eng1_daily.sh':}
    cronjob::do_cron_dot_d_script {'eng1_similar_batch1.sh':}
    cronjob::do_cron_dot_d_script {'eng1_similar_batch2.sh':}
    cronjob::do_cron_dot_d_script {'kill_runaway_cronjobs.pl':}
    cronjob::do_cron_dot_d_script {'find_overlapping_cronjobs_stage.sh':}
    cronjob::do_cron_dot_d_script {'email_fatal_errors_stage.sh':}

    common::nfsmount { '/app/shared':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_stg_app_shared/ci-shared',
    }

    common::nfsmount { '/app/log':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_stg_app_log/eng1v-ci.ci.stg.lax.gnmedia.net',
    }

    # this is a separated tmp directory for cakephp
    common::nfsmount { '/app/tmp':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_stg_app_shared/app_ci_tmp',
    }

    ### copy all of the cron data somewhere the devs have access to
    file { '/app/log/cronjobs/jobspec/eng1_stg.cron':
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => 'puppet:///modules/cronjob/cron.d/crowdignite_engine/eng1.cron',
    }

    file { '/app/log/cronjobs/jobspec/eng1_short.sh':
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => 'puppet:///modules/cronjob/cron.d/crowdignite_engine/eng1_short.sh',
    }

    file { '/app/log/cronjobs/jobspec/eng1_rebalance.sh':
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => 'puppet:///modules/cronjob/cron.d/crowdignite_engine/eng1_rebalance.sh',
    }

    file { '/app/log/cronjobs/jobspec/eng1_daily.sh':
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => 'puppet:///modules/cronjob/cron.d/crowdignite_engine/eng1_daily.sh',
    }

    file { '/app/log/cronjobs/jobspec/eng1_similar_batch1.sh':
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => 'puppet:///modules/cronjob/cron.d/crowdignite_engine/eng1_similar_batch1.sh',
    }

    file { '/app/log/cronjobs/jobspec/eng1_similar_batch2.sh':
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => 'puppet:///modules/cronjob/cron.d/crowdignite_engine/eng1_similar_batch2.sh',
    }

    file { '/app/log/cronjobs/jobspec/kill_runaway_cronjobs.pl':
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => 'puppet:///modules/cronjob/cron.d/crowdignite_engine/kill_runaway_cronjobs.pl',
    }

    file { '/app/log/cronjobs/jobspec/find_overlapping_cronjobs_stage.sh':
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => 'puppet:///modules/cronjob/cron.d/crowdignite_engine/find_overlapping_cronjobs_stage.sh',
    }

    file { '/app/log/cronjobs/jobspec/email_fatal_errors_stage.sh':
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => 'puppet:///modules/cronjob/cron.d/crowdignite_engine/email_fatal_errors_stage.sh',
    }

}
