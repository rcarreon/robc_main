node 'app1v-pubops.ap.stg.lax.gnmedia.net' {
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
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_stg_app_log/app1v-pubops.ap.stg.lax.gnmedia.net",
    }

#   httpd::virtual_host {"stg.pubops.evolvemediacorp.com": uri => '/robots.txt', expect => 'User-agent'}
    httpd::virtual_host {"newstg.pubops.evolvemediacorp.com": uri => '/robots.txt', expect => 'User-agent'}
#    httpd::virtual_host {"stg.cta.pubops.gorillanation.com": uri => '/robots.txt', expect => 'norobots'}
#    httpd::virtual_host {"stg.cta.pubops.gorillanation.com": monitor => false}

    ## app_pubops database.php
    ### ro creds
    $host_adops_app_pubops_ro = "vip-sqlro-pubops.ap.stg.lax.gnmedia.net"
    $user_adops_app_pubops_ro = "pubops_r"
    $pw_adops_app_pubops_ro = decrypt("x604TcrsN5XY8TZIfhEA8XLPW9J+okgmAPisPahRmDs=")

    ### rw creds
    $host_adops_app_pubops_rw = "vip-sqlrw-adops.ap.stg.lax.gnmedia.net"
    $user_adops_app_pubops_rw = "pubops_w"
    $pw_adops_app_pubops_rw = decrypt("GQZboUaPVahqdIiemjsDMWt4YNQ7ibYBJ4LefSM4Upg=")

    ### pubops_reports
    $url_adops_app_pubops_pubops_reports = "https://stg.adops.gorillanation.com/pubops_reports_v3"
    $user_adops_app_pubops_pubops_reports = ""
    $pw_adops_app_pubops_pubops_reports = "" # this was in with a dev url and had blank login info, but I thought I should template it anyways

    file {"/app/shared/docroots/adopsV3/config/app_pubops.database.php":
        content => template("adops/app_pubops.database.php.erb"),
        owner   => "root",
        group   => "root",
    }
}
