node 'uid1v-zandranigian.tp.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="admin"
    class {"mysqld56": template=>"zandranigian.tp.dev.lax-standalone"}
    include memcached
    include common::app

    common::nfsmount { "/sql/data":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_zandranigian_tp_dev_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_zandranigian_tp_dev_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_sql_log/uid1v-zandranigian.tp.dev.lax.gnmedia.net",
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_uid_shared/zandranigian-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_app_log/uid1v-zandranigian.tp.dev.lax.gnmedia.net",
    }

    common::nfsmount { "/app/ugc":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_uid_ugc/zandranigian-ugc",
    }

    common::nfsmount { "/pxy/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_pxy_log/uid1v-zandranigian.tp.dev.lax.gnmedia.net",
    }
}
