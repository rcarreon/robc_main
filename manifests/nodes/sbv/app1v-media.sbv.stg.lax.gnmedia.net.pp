node 'app1v-media.sbv.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="springboard"

        include common::app
	include httpd
	include php::media
        include ganglia::modules::mod_sflow
        include pythondeployer

	# Cap deploys neccesitates a server with subversion installed.
	package { "subversion":
		ensure => installed,	
	}

        cron { "sitemaps_cron":
		ensure  => absent,
                command => "/usr/bin/php /app/shared/docroots/cms.springboardplatform.com/current/modules/sitemaps/sitemaps_cron.php",
                user    => "apache",
                hour    => "0",
        }

	httpd::virtual_host {"stg.media.springboard.gorillanation.com":}
	httpd::virtual_host {"stg.cms.springboard.gorillanation.com":}


        common::nfsmount { "/app/shared":
		device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_stg_app_shared/media-shared",
        }


        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_stg_app_log/app1v-media.sbv.stg.lax.gnmedia.net",
        }

	common::nfsmount { "/app/ugc":
		device => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sbv_lax_stg_app_ugc",
	}
}
