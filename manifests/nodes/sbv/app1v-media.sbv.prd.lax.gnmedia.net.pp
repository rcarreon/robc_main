node 'app1v-media.sbv.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project='springboard'

    include common::app
    include httpd
    include php::media
    include ganglia::modules::mod_sflow
    include pythondeployer

    # Cap deploys neccesitates a server with subversion installed.
    package { 'subversion':
        ensure => installed,
    }

    cron { 'sitemaps_cron':
        ensure  => absent,
        command => '/usr/bin/php /app/shared/docroots/cms.springboardplatform.com/current/modules/sitemaps/sitemaps_cron.php',
        user    => 'apache',
        hour    => '0',
    }

    cron { 'sheknows_cron':
        ensure  => absent,
        command => '/usr/bin/php /app/shared/docroots/cms.springboardplatform.com/current/modules/sheknows/sheknows_cron.php',
        user    => 'apache',
        weekday => '0',
        hour    => '1',
    }

    cron { 'incomingCleanup':
        ensure  => present,
        command => 'bash /usr/local/bin/incomingCleanup',
        hour    => '2',
        minute  => '0',
        weekday => '6',
    }

    file { 'incomingCleanup':
        ensure  => file,
        path    => '/usr/local/bin/incomingCleanup',
        content => template('springboard/incomingCleanup.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }

    httpd::virtual_host {'media.springboard.gorillanation.com':
        uri    => '/crossdomain.xml',
        expect => 'domain',
    }

    httpd::virtual_host {'cms.springboard.gorillanation.com':
        uri    => '/embed_iframe/19/video/838171/gn149/gorillanation.com/10',
        expect => 'Starfire',
    }

    common::nfsmount { '/app/shared':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_prd_app_shared/media-shared',
    }

    common::nfsmount { '/app/log':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_prd_app_log/app1v-media.sbv.prd.lax.gnmedia.net',
    }

    common::nfsmount { '/app/ugc':
        device => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_sbv_lax_prd_app_ugc/ugc',
    }
}
