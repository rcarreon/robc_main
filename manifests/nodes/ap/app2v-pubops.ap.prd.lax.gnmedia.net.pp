node 'app2v-pubops.ap.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="adops"
    include adops::packages::v3
    include adopsV3::appdirs

    class { "php::adops_memcache":
        memcache_servers => ["mem1v-adops.ap.prd.lax.gnmedia.net","mem2v-adops.ap.prd.lax.gnmedia.net"]
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_shared/adops-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_prd_app_log/app2v-pubops.ap.prd.lax.gnmedia.net",
    }

    httpd::virtual_host {"newprod.pubops.evolvemediacorp.com": uri => '/robots.txt', expect => 'User-agent'}
#    httpd::virtual_host {"cta.pubops.evolvemediacorp.com": uri => '/robots.txt', expect => 'norobots'}
#    httpd::virtual_host {"cta.pubops.evolvemediacorp.com": monitor => false}
#    httpd::virtual_host {"pubops.gorillanation.com": monitor => false}

}
