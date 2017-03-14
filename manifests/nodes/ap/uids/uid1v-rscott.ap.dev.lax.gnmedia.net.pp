node 'uid1v-rscott.ap.dev.lax.gnmedia.net' {
    include base

    $project='adops'

    include adops::packages
    include adops::packages::v3
    include adopsV3::appdirs
    include sendmail::tarpit
    include php::adops
    include adops::rbenv
    include adops::uid
    include yum::adopsext::wildwest

    $redis_password = decrypt('Z6nFQRkg3mC8W74JDAdYXQbI5vBiYAYCOiQdTqOkxHcXpPuajeIFLHtO+S25smve')
    redis::store {"adops":
      name => 'adops'
    }

    package {'nodejs':
      ensure => installed
    }

    # class {"mysqld56": template=>"adops.ap.dev.lax-standalone"}

    common::nfsmount { "/sql/data":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_rscott_ap_dev_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_rscott_ap_dev_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_sql_log/uid1v-rscott.ap.dev.lax.gnmedia.net",
    }

    common::nfsromount { "/app/software":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/ap-software-dev",
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_uid_shared/rscott-shared",
    }

}
