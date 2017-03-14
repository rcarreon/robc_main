node 'app4v-media.sbv.prd.lax.gnmedia.net' {
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


        httpd::virtual_host {"media.springboard.gorillanation.com":
            uri    => "/crossdomain.xml",
            expect => "domain",
        }
        httpd::virtual_host {"cms.springboard.gorillanation.com":
            uri    => "/embed_iframe/19/video/838171/gn149/gorillanation.com/10",
            expect => "Starfire",
        }
        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_prd_app_shared/media-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sbv_lax_prd_app_log/app4v-media.sbv.prd.lax.gnmedia.net",
        }

        common::nfsmount { "/app/ugc":
                device => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sbv_lax_prd_app_ugc/ugc",
        } 
}
