node 'app1v-media.sbv.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
      include base
      $project="springboard"

      include common::app
      include httpd
      include php::media
      include subversion::client
      include pythondeployer

      httpd::virtual_host {"dev.media.springboard.gorillanation.com":}
      httpd::virtual_host {"dev.cms.springboard.gorillanation.com":}

      common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_dev_app_shared/media-shared",
      }

      common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_dev_app_log/app1v-media.sbv.dev.lax.gnmedia.net",
      }

      common::nfsmount { "/app/log/cms-logs":
        device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_dev_app_log/cms-logs",
      }


      common::nfsmount { "/app/ugc":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sbv_lax_dev_app_ugc",
      }

}
