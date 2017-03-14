node 'app1v-cms.sbv.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project='springboard'
    include common::app
    include httpd
    include php::cms
    include logrotate::sbv
    include ganglia::modules::mod_sflow
    include pythondeployer

    package { 'php-pear':
        ensure => installed
    }

    package { 'ffmpeg':
        ensure => present,
    }

    cron { 'fetch_flv':
        command => '/usr/bin/php /app/shared/docroots/cms.springboardplatform.com/current/modules/fetch_flv_springboard/fetch_flv.php',
        user    => 'apache',
        minute  => '*',
    }

    cron { 'sendNewsletter':
        command => '/usr/bin/php /app/shared/docroots/cms.springboardplatform.com/current/modules/newsletter/sendNewsletter.php',
        user    => 'apache',
        minute  => '0',
        hour    => '*',
    }

    cron { 'dashboard':
        command => '/usr/bin/php /app/shared/docroots/cms.springboardplatform.com/current/modules/fetch_flv_springboard/dashboard_cron.php',
        user    => 'apache',
        hour    => 1,
        minute  => 0,
    }

    cron { 'ftpupload':
        ensure  => present,
        command => '/usr/bin/php /app/shared/docroots/cms.springboardplatform.com/current/modules/ftp_upload/ftp_upload_cron.php',
        user    => 'apache',
        minute  => '*/15',
    }

    cron { 'cpv_adops_sync':
        command => '/usr/bin/php /app/shared/docroots/cms.springboardplatform.com/current/modules/adops/doCpvSync.php',
        user    => 'apache',
        hour    => '*/6',
        minute  => '0',
    }

    cron { 'get_ocr_data':
        ensure  => present,
        command => '/usr/bin/php /app/shared/docroots/cms.springboardplatform.com/current/modules/ocr/getOcrData.php',
        user    => 'apache',
        hour    => '*/6',
        minute  => '0',
    }

    file { '/usr/local/bin/rantsports_modules.sh':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => "#!/bin/bash\n/usr/bin/php /app/shared/docroots/cms.springboardplatform.com/current/modules/rantsports/rantsports_module.php\n/usr/bin/php /app/shared/docroots/cms.springboardplatform.com/current/modules/rantsports/rantsports_module_2.php\n/usr/bin/php /app/shared/docroots/cms.springboardplatform.com/current/modules/rantsports/rantsports_module_3.php",
    }

    cron { 'rantsports_modules':
        ensure  => present,
        command => 'bash /usr/local/bin/rantsports_modules.sh',
        user    => 'apache',
        hour    => '3',
        minute  => '0',
    }

    cron { 'nesn_com_partner':
        ensure  => present,
        command => '/usr/bin/php  /usr/bin/php /app/shared/docroots/cms.springboardplatform.com/current/modules/nesn/nesn.php',
        user    => 'apache',
	hour 	=> '3',
	minute	=> '0'
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

    httpd::virtual_host {'publishers.springboard.gorillanation.com':}
    httpd::virtual_host {'cms.atomiconline.com':}

    common::nfsmount { '/app/shared':
        device => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_prd_app_shared/cms-shared',
    }

    common::nfsmount { '/app/log':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_prd_app_log/app1v-cms.sbv.prd.lax.gnmedia.net',
    }

    common::nfsmount { '/app/ugc':
        device => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_sbv_lax_prd_app_ugc/ugc',
    }

    file { '/app/shared/cms-logs/batch_upload':
        ensure  => directory,
        owner   => 'apache',
        group   => 'apache',
        require => File['/app/shared/cms-logs'],
    }

    file { '/app/shared/cms-logs/celebtv_feed':
        ensure  => directory,
        owner   => 'apache',
        group   => 'apache',
        require => File['/app/shared/cms-logs'],
    }

    file { '/app/shared/cms-logs/cpv':
        ensure  => directory,
        owner   => 'apache',
        group   => 'apache',
        require => File['/app/shared/cms-logs'],
    }
    file { '/app/shared/cms-logs/fetch':
        ensure  => directory,
        owner   => 'apache',
        group   => 'apache',
        require => File['/app/shared/cms-logs'],
    }

    file { '/app/shared/cms-logs/newsletter':
        ensure  => directory,
        owner   => 'apache',
        group   => 'apache',
        require => File['/app/shared/cms-logs'],
    }

    file { '/app/shared/cms-logs/upload':
        ensure  => directory,
        owner   => 'apache',
        group   => 'apache',
        require => File['/app/shared/cms-logs']
    }

}
