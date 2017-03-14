node 'uid1v-lgalaz.si.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base

    common::nfsmount { "/sql/data":
        device  => "nfsA-netapp1.tp.prd.lax.gnmedia.net:/vol/nac1a_uid1v_lgalaz_si_dev_lax_sbx/sql/data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsA-netapp1.tp.prd.lax.gnmedia.net:/vol/nac1a_uid1v_lgalaz_si_dev_lax_sbx/sql/binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsA-netapp1.tp.prd.lax.gnmedia.net:/vol/nac1a_uid1v_lgalaz_si_dev_lax_sbx/sql/log",
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.tp.prd.lax.gnmedia.net:/vol/nac1a_uid1v_lgalaz_si_dev_lax_sbx/appshared",
    }
}
