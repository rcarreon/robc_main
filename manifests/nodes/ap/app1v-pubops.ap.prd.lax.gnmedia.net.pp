node 'app1v-pubops.ap.prd.lax.gnmedia.net' {
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
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_log/app1v-pubops.ap.prd.lax.gnmedia.net",
    }

    httpd::virtual_host {"newprod.pubops.evolvemediacorp.com": uri => '/robots.txt', expect => 'User-agent'}
#    httpd::virtual_host {"cta.pubops.evolvemediacorp.com": uri => '/robots.txt', expect => 'norobots'}
#    httpd::virtual_host {"cta.pubops.evolvemediacorp.com": monitor => false}
#    httpd::virtual_host {"pubops.gorillanation.com": monitor => false}

    ## app_pubops database.php
    ### ro creds
    $host_adops_app_pubops_ro = "VIP-SQLRO-pubops.AP.PRD.LAX.gnmedia.net"
    $user_adops_app_pubops_ro = "pubops_r"
    $pw_adops_app_pubops_ro = decrypt("e+bvB3H2fMJEU0h9NHBOJg==")

    ### rw creds
    $host_adops_app_pubops_rw = "VIP-SQLRW-adops.AP.PRD.LAX.gnmedia.net"
    $user_adops_app_pubops_rw = "pubops_w"
    $pw_adops_app_pubops_rw = decrypt("b/6DAyb4nNZTWkLa0rp5CD0vSEAdkB5cbMvZFU6+Pjg=")

    ### pubops_reports
    $url_adops_app_pubops_pubops_reports = "https://adops.gorillanation.com/pubops_reports_v3"
    $user_adops_app_pubops_pubops_reports = ""
    $pw_adops_app_pubops_pubops_reports = ""

    file {"/app/shared/docroots/adopsV3/config/app_pubops.database.php":
        content => template("adops/app_pubops.database.php.erb"),
        owner   => "root",
        group   => "root",
    }
}
