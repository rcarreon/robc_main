node 'uid1v-ifimbres.ap.dev.lax.gnmedia.net' {
    include base
    $project='adops'

    include yum::adopsext::wildwest

    class {"mysqld56": template=>"adops.ap.dev.lax-standalone"}

    $redis_password = decrypt("S/qLujzYmxFWw8wDk6DdvA==")
    redis::store{"adops":}

    common::nfsmount { "/sql/data":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_ifimbres_ap_dev_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_ifimbres_ap_dev_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_sql_log/uid1v-ifimbres.ap.dev.lax.gnmedia.net",
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_uid_shared/ifimbres-shared",
    }
}
