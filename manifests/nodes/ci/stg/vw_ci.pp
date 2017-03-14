class crowdignite::vw_ci_stg {

    include yum::ius
    include php::ius
    include php::ius::memcached
    include php::browscap
    include logrotate::crowdignite_cronjobs
    include vowpalwabbit::widget
    include vowpalwabbit::landing
    include vowpalwabbit::cpc
    include vowpalwabbit::healthcheck
    include vowpalwabbit::viewbility

    vowpalwabbit::failurelogcheck { '/app/log/vw_landing-page-error_log' : }
    vowpalwabbit::failurelogcheck { '/app/log/vw_widget-error_log': }

    monit::stale_file_check { 'vw_widget_check':
        stale_file_abs_path   => '/app/data/vwmodels.live/widget.model',
        stale_file_minutes    => 60,
    }

    monit::stale_file_check { 'vw_landing_check':
        stale_file_abs_path   => '/app/data/vwmodels.live/landing.model',
        stale_file_minutes    => 60,
    }

    # we want the updates-live mysql-libs
    package { ['mysqlclient16', 'mysql55-libs']:
        ensure => absent,
    }

    ### DEV only pkgs
    package { 'vim-enhanced':
      ensure => installed,
    }

    # dirs for vw consolidator
    file { ['/mnt',# remove after app/data vols used
            '/mnt/crowdignite',# remove after app/data vols used
            '/app/data/vwlogs',
            '/app/data/vwinput',
            '/app/data/vwinput.done',
            '/app/data/vwinput.failed',
            '/app/data/vwmodels',
            '/app/data/vwmodels.live',
            '/app/data/vwmodels/landing',
            '/app/data/vwmodels/widget',
            '/app/data/landinganalytics',
            '/app/data/landinganalytics/failed',
            '/app/data/widgetanalytics',
            '/app/data/widgetanalytics/failed']:
        ensure  => directory,
        mode    => '0755',
        owner   => apache,
        group   => apache,
    }

    file { '/usr/local/bin/crowdignite_engine/set_cache.php':
        owner   => root,
        group   => root,
        mode    => '0755',
        source  => 'puppet:///modules/cronjob/cron.d/crowdignite_engine/set_cache.php',
    }

    ### cronjobs cronspec for dev viewing
    file { ['/app/log/cronjobs', '/app/log/cronjobs/jobspec/']:
        ensure  => directory,
        owner   => apache,
        group   => apache,
        mode    => '0755',
    }

    ### Mount all of the environments app/ngx data dirs #NEW SYNTAX
    common::nfsmount { '/app/data/landinganalytics/app1v-ci.ci.stg.lax.gnmedia.net':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_stg_app_data/app1v-ci.ci.stg.lax.gnmedia.net',
    }

    common::nfsmount { '/app/data/landinganalytics/app2v-ci.ci.stg.lax.gnmedia.net':
        device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ci_lax_stg_app_data/app2v-ci.ci.stg.lax.gnmedia.net',
    }

    common::nfsmount { '/app/data/widgetanalytics/ngx1v-ci.ci.stg.lax.gnmedia.net':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_stg_app_data/ngx1v-ci.ci.stg.lax.gnmedia.net',
    }

    common::nfsmount { '/app/data/widgetanalytics/ngx2v-ci.ci.stg.lax.gnmedia.net':
        device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ci_lax_stg_app_data/ngx2v-ci.ci.stg.lax.gnmedia.net',
    }

    common::nfsmount { '/app/data/widgetanalytics/ngx3v-ci.ci.stg.lax.gnmedia.net':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_stg_app_data/ngx3v-ci.ci.stg.lax.gnmedia.net',
    }

    common::nfsmount { '/app/data/widgetanalytics/ngx4v-ci.ci.stg.lax.gnmedia.net':
        device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ci_lax_stg_app_data/ngx4v-ci.ci.stg.lax.gnmedia.net',
    }

    ### Mount all of the environments app/ngx data dirs #OLD DELETE ME SYNTAX AFTER AZ926 DEPLOYED
    common::nfsmount { '/mnt/crowdignite/app1v-ci.ci.stg.lax.gnmedia.net':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_stg_app_data/app1v-ci.ci.stg.lax.gnmedia.net',
    }

    common::nfsmount { '/mnt/crowdignite/app2v-ci.ci.stg.lax.gnmedia.net':
        device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ci_lax_stg_app_data/app2v-ci.ci.stg.lax.gnmedia.net',
    }

    common::nfsmount { '/mnt/crowdignite/ngx1v-ci.ci.stg.lax.gnmedia.net':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_stg_app_data/ngx1v-ci.ci.stg.lax.gnmedia.net',
    }

    common::nfsmount { '/mnt/crowdignite/ngx2v-ci.ci.stg.lax.gnmedia.net':
        device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ci_lax_stg_app_data/ngx2v-ci.ci.stg.lax.gnmedia.net',
    }

    common::nfsmount { '/mnt/crowdignite/ngx3v-ci.ci.stg.lax.gnmedia.net':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_stg_app_data/ngx3v-ci.ci.stg.lax.gnmedia.net',
    }

    common::nfsmount { '/mnt/crowdignite/ngx4v-ci.ci.stg.lax.gnmedia.net':
        device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ci_lax_stg_app_data/ngx4v-ci.ci.stg.lax.gnmedia.net',
    }

}
