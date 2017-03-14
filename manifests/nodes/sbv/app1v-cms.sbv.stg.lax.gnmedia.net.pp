node 'app1v-cms.sbv.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="springboard"

        include common::app
	include httpd
	include php::cms
	include logrotate::sbv
        include ganglia::modules::mod_sflow
        include pythondeployer

        package { "ffmpeg":
            ensure => present,
        }

	httpd::virtual_host {"stg.publishers.springboard.gorillanation.com":}
	httpd::virtual_host {"stg.cms.atomiconline.com":}

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_stg_app_shared/cms-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_stg_app_log/app1v-cms.sbv.stg.lax.gnmedia.net",
        }

        common::nfsmount { "/app/ugc":
                device => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sbv_lax_stg_app_ugc",
        }

        package { "php-pear":
                ensure => installed
        }

        cron { "cpv_adops_sync":
            command => "/usr/bin/php /app/shared/docroots/cms.springboardplatform.com/current/modules/adops/doCpvSync.php",
            user    => "apache",
            hour    => "*/6",
            minute  => '0',
        }
        cron { "fetch_flv":
                command => "/usr/bin/php /app/shared/docroots/cms.springboardplatform.com/current/modules/fetch_flv_springboard/fetch_flv.php",
                user    => "apache",
                minute  => "*",
        }
	cron { "dashboard":
		command => "/usr/bin/php /app/shared/docroots/cms.springboardplatform.com/current/modules/fetch_flv_springboard/dashboard_cron.php",
		user    => "apache",
		hour    => 1,
		minute  => 0,
	}
        cron { "sbv_newsletter":
                command => "/usr/bin/php /app/shared/docroots/cms.springboardplatform.com/current/modules/newsletter/sendNewsletter.php",
                user    => "apache",
                hour    => "*/1",
                minute  => "0",
        }

        cron { 'get_orc_data':
            command => '/usr/bin/php /app/shared/docroots/cms.springboardplatform.com/current/modules/ocr/getOcrData.php',
            user    => 'apache',
            hour    => '*/6',
            minute  => '0'
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
