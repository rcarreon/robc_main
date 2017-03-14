node 'uid1v-cdrottar.ap.dev.lax.gnmedia.net' {
    include base
    $project='adops'

    include adops::packages
    include adopsV3::appdirs
    include sendmail::tarpit
    include php::adops
    include adops::rbenv
    include adops::uid
    include yum::adopsext::wildwest

    package { ['ruby-devel','gcc']:
        ensure => installed,
    }

    # class {"mysqld56": template=>"adops.ap.dev.lax-standalone"}

    common::nfsmount { "/sql/data":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_cdrottar_ap_dev_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_cdrottar_ap_dev_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_sql_log/uid1v-cdrottar.ap.dev.lax.gnmedia.net",
    }

    common::nfsromount { "/app/software":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/ap-software-dev",
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_uid_shared/cdrottar-shared",
    }
}
