node 'eng1v-ci.ci.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base

    $env='stg'
    $httpd='crowdignite'
    $project='crowdignite_engine'
    $script_path='crowdignite_engine'
    include crowdignite::eng_ci_dev

# 	 $script_path="crowdignite_engine"
#    include cronjob
#    cronjob::do_cron_dot_d_cron_file {"eng1.cron": }

#    cronjob::do_cron_dot_d_script {"eng1_short.sh":}
#    cronjob::do_cron_dot_d_script {"eng1_rebalance.sh":}
#    cronjob::do_cron_dot_d_script {"eng1_daily.sh":}

    common::nfsmount { '/app/shared':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_dev_app_shared/ci-shared',
    }

    common::nfsmount { '/app/log':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_dev_app_log/eng1v-ci.ci.dev.lax.gnmedia.net',
    }

    common::nfsmount { '/app/tmp':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_dev_app_shared/app_ci_tmp',
    }

}
