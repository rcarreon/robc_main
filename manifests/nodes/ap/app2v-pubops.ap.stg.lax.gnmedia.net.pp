node 'app2v-pubops.ap.stg.lax.gnmedia.net' {
    include base
    $project="adops"
    include adops::packages::v3
    include adops::devmail
    #include sendmail::tarpit
    include adopsV3::appdirs

    include newrelic
    include newrelic::params
    include newrelic::nfsiostat
    include newrelic::sysmond

    class { "php::adops_memcache":
        memcache_servers => ["mem1v-adops.ap.stg.lax.gnmedia.net","mem2v-adops.ap.stg.lax.gnmedia.net"]
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_stg_app_shared/adops-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_stg_app_log/app2v-pubops.ap.stg.lax.gnmedia.net",
    }

#    httpd::virtual_host {"stg.pubops.evolvemediacorp.com": uri => '/robots.txt', expect => 'User-agent'}
    httpd::virtual_host {"newstg.pubops.evolvemediacorp.com": uri => '/robots.txt', expect => 'User-agent'}
#    httpd::virtual_host {"stg.cta.pubops.gorillanation.com": uri => '/robots.txt', expect => 'norobots'}
#    httpd::virtual_host {"stg.cta.pubops.gorillanation.com": monitor => false}
}
