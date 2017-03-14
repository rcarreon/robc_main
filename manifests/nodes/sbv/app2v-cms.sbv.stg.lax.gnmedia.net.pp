node 'app2v-cms.sbv.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="springboard"

        include common::app
        include httpd
	include php::cms
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
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sbv_lax_stg_app_log/app2v-cms.sbv.stg.lax.gnmedia.net",
        }

        common::nfsmount { "/app/ugc":
                device => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sbv_lax_stg_app_ugc",
        }
	
        package { "php-pear":
                ensure => installed
        }
}
