node 'app1v-stats-cms.sbv.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="springboard"
        $httpd="sbv-stats"
        include ganglia::modules::sbv_stats
        include ganglia::modules::mod_sflow
	include httpd
        include common::app
	include cms::stats::stage
        include pythondeployer


	$sbvGeoIPLicense=decrypt("L0K3qxm/4u6FIVQ5sNvETA==")
	$sbvGeoIPUserID="32923"
	$sbvGeoIPProductID="133"

        httpd::virtual_host {"analytics.stg.springboardvideo.com":
                expect => "[OK] APPLICATION HEALTHCHECK",
                uri    => "/healthcheck.php",
        }

	# Cap deploys neccesitates a server with subversion installed.
	package { "subversion":
		ensure => installed,	
	}

	common::nfsmount { "/app/shared":
		device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_stg_app_shared/stats-shared",
	}

	file { "/etc/GeoIP.conf":
		ensure  => present,
		content => "LicenseKey $sbvGeoIPLicense\nUserId $sbvGeoIPUserID\nProductIds $sbvGeoIPProductID\n",
		owner   => "root",
		group   => "root",
		mode    => "644",
	}	

	cron { "geoip":
		user    => "deploy",
		minute  => "0",
		hour    => "12",
		weekday => "3",
		command => "/usr/bin/geoipupdate -f /etc/GeoIP.conf -d /app/shared/docroots/geoip/",
	}

        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_stg_app_log/app1v-stats-cms.sbv.stg.lax.gnmedia.net",
        }
}
