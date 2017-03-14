node 'app1v-cms.sbv.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project='springboard'

    include common::app
#    include admin::ipv6_disable
    include httpd
    include php::cms
    include subversion::client
    include logrotate::sbv
    include pythondeployer

    package { 'ffmpeg':
        ensure => present,
    }

    httpd::virtual_host {'dev.publishers.springboard.gorillanation.com':}
    httpd::virtual_host {'dev.cms.atomiconline.com':}

    common::nfsmount { '/app/shared':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_dev_app_shared/cms-shared',
    }

    common::nfsmount { '/app/log':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_dev_app_log/app1v-cms.sbv.dev.lax.gnmedia.net',
    }

    common::nfsmount { '/app/log/cms-logs':
        device => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_dev_app_log/cms-logs',
    }

    common::nfsmount { '/app/ugc':
        device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_sbv_lax_dev_app_ugc',
    }

    package { 'php-pear':
        ensure => installed,
    }

    cron { 'fetch_flv':
        command => '/usr/bin/php /app/shared/docroots/cms.springboardplatform.com/current/modules/fetch_flv_springboard/fetch_flv.php',
        user    => 'apache',
        minute  => '*',
    }
    cron { 'dashboard_cron':
        command => '/usr/bin/php /app/shared/docroots/cms.springboardplatform.com/current/modules/fetch_flv_springboard/dashboard_cron.php',
        user    => 'apache',
        minute  => '0',
        hour    => '0',
    }
    cron { 'cpv_adops_sync':
        command => '/usr/bin/php /app/shared/docroots/cms.springboardplatform.com/current/modules/adops/doCpvSync.php',
        user    => 'apache',
        hour    => '*/6',
        minute  => '0',
    }
    cron { "sbv_newsletter":
        command => '/usr/bin/php /app/shared/docroots/cms.springboardplatform.com/current/modules/newsletter/sendNewsletter.php',
        user    => 'apache',
        hour    => '*/1',
        minute  => '0',
    }
    cron { 'get_video':
        command => '/usr/bin/php /app/shared/docroots/cms.springboardplatform.com/current/modules/encoding/get_video.php',
        user    => 'apache',
        minute  => '*',
    }

    cron { 'getOcrData':
        command => '/usr/bin/php /app/shared/docroots/cms.springboardplatform.com/current/modules/ocr/getOcrData.php',
        user    => 'apache',
        hour    => '*/6',
        minute  => '0',
    }

    cron { 'getalllineitems':
        command => '/usr/bin/php /app/shared/docroots/cms.springboardplatform.com/current/modules/dfp/GetAllLineItems.php',
        user    => 'apache',
        hour    => ['1','4','7','10','13','16','19','22'],
        minute  => '0'
    }

    cron { 'getalladunits':
        command => '/usr/bin/php /app/shared/docroots/cms.springboardplatform.com/current/modules/dfp/GetAllAdUnits.php',
        user    => 'apache',
        hour    => ['3', '15'],
        minute  => '0'
    }

    cron { 'getallcustomtargetingkeysandvalues':
        command => '/usr/bin/php /app/shared/docroots/cms.springboardplatform.com/current/modules/dfp/GetAllCustomTargetingKeysAndValues.php',
        user    => 'apache',
        hour    => ['6', '18'],
        minute  => '0'
    }
}
