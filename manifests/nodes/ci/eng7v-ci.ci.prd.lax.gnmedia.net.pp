node 'eng7v-ci.ci.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $httpd='crowdignite'
    $project='crowdignite_engine'
    include crowdignite::eng_ci_prd
    package { 'php54-mbstring':
        ensure => 'installed'
    }

    $script_path='crowdignite_engine'
    include cronjob
#       cronjob::do_cron_dot_d_cron_file {"eng7.cron": }
#       cronjob::do_cron_dot_d_script {"kill_runaway_cronjobs.pl":}

    common::nfsmount { '/app/shared':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_prd_app_shared/ci-shared',
    }

    common::nfsmount { '/app/log':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_prd_app_log/eng7v-ci.ci.prd.lax.gnmedia.net',
    }

    # this is a separated tmp directory for cakephp
    common::nfsmount { '/app/tmp':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_prd_app_shared/app_ci_tmp',
    }

}
