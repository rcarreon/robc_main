node 'uid1v-msantiago.ap.dev.lax.gnmedia.net' {
    include base
    $project = "adops"
    $prefix = "ap"
    include adops::packages
    include adops::packages::v3
    include adops::mod_passenger
    include adopsV3::appdirs
    include sendmail::tarpit
    include php::adops
    include adops::rbenv
    include adops::uid
    include yum::adopsext::wildwest

    # class {"mysqld56": template=>"adops.ap.dev.lax-standalone"}
    
    httpd::virtual_host {"dev.adops.gorillanation.com": uri => '/robots.txt', expect => 'norobots'}
    httpd::virtual_host {"dev.pubops.gorillanation.com": uri => '/robots.txt', expect => 'norobots'}

    common::nfsmount { "/sql/data":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_msantiago_ap_ap_dev_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_msantiago_ap_ap_dev_lax_binlog",
        }

    common::nfsmount { "/sql/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_sql_log/uid1v-msantiago-ap.ap.dev.lax.gnmedia.net",
    }

    common::nfsromount { "/app/software":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/ap-software-dev",
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_uid_shared/msantiago-shared",
    }

}
