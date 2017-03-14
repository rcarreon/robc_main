node 'eng2v-ci.ci.stg.lax.gnmedia.net' {
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
    cronjob::do_cron_dot_d_cron_file {'eng2_stg.cron': }

    cronjob::do_cron_dot_d_script {'eng2_short.sh':}
    cronjob::do_cron_dot_d_script {'eng2_rebalance.sh':}
    cronjob::do_cron_dot_d_script {'eng2_daily.sh':}
    cronjob::do_cron_dot_d_script {'eng2_ranker.sh':}
    cronjob::do_cron_dot_d_script {'kill_runaway_cronjobs.pl':}
    cronjob::do_cron_dot_d_script {'eng2_social_2xperday.sh':}
    cronjob::do_cron_dot_d_script {'eng2_social_4xperday.sh':}
    cronjob::do_cron_dot_d_script {'find_overlapping_cronjobs_stage.sh':}
    cronjob::do_cron_dot_d_script {'email_fatal_errors_stage.sh':}

    common::nfsmount { '/app/shared':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_stg_app_shared/ci-shared',
    }

    common::nfsmount { '/app/log':
        device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ci_lax_stg_app_log/eng2v-ci.ci.stg.lax.gnmedia.net',
    }

    # this is a separated tmp directory for cakephp
    common::nfsmount { '/app/tmp':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_stg_app_shared/app_ci_tmp',
    }

    ### copy all of the cron data somewhere the devs have access to
    file { '/app/log/cronjobs/jobspec/eng2_stg.cron':
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => 'puppet:///modules/cronjob/cron.d/crowdignite_engine/eng2_stg.cron',
    }

    file { '/app/log/cronjobs/jobspec/eng2_ranker.sh':
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => 'puppet:///modules/cronjob/cron.d/crowdignite_engine/eng2_ranker.sh',
    }

    file { '/app/log/cronjobs/jobspec/eng2_short.sh':
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => 'puppet:///modules/cronjob/cron.d/crowdignite_engine/eng2_short.sh',
    }

    file { '/app/log/cronjobs/jobspec/eng2_rebalance.sh':
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => 'puppet:///modules/cronjob/cron.d/crowdignite_engine/eng2_rebalance.sh',
    }

    file { '/app/log/cronjobs/jobspec/eng2_daily.sh':
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => 'puppet:///modules/cronjob/cron.d/crowdignite_engine/eng2_daily.sh',
    }

    file { '/app/log/cronjobs/jobspec/kill_runaway_cronjobs.pl':
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => 'puppet:///modules/cronjob/cron.d/crowdignite_engine/kill_runaway_cronjobs.pl',
    }

    file { '/app/log/cronjobs/jobspec/eng2_social_2xperday.sh':
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => 'puppet:///modules/cronjob/cron.d/crowdignite_engine/eng2_social_2xperday.sh',
    }

    file { '/app/log/cronjobs/jobspec/eng2_social_4xperday.sh':
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => 'puppet:///modules/cronjob/cron.d/crowdignite_engine/eng2_social_4xperday.sh',
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
