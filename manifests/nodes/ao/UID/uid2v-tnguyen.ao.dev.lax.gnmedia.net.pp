node 'uid2v-tnguyen.ao.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base

    $username="tnguyen"
    $project="atomiconline"
    include ao::uid2::devserver
    include ao::uid2::pbwb_uid_dbcred
    include yum::ius

    common::nfsmount { "/sql/data":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid2v_tnguyen_ao_dev_lax_sbx/sql/data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid2v_tnguyen_ao_dev_lax_sbx/sql/binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid2v_tnguyen_ao_dev_lax_sbx/sql/log",
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid2v_tnguyen_ao_dev_lax_sbx/appshared",
    }

}
