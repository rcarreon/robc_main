node 'sql3v-test.tp.dev.lax.gnmedia.net' {
    include base
    $project="admin"
    include mysqld::server::ci_replcerts
    class {"mysqld56": template=>"test-standalone", sqlclass=>"supported"}

    common::nfsmount { "/sql/data":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql3v_test_tp_dev_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql3v_test_tp_dev_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_sql_log/sql3v-test.tp.dev.lax.gnmedia.net",
    }
}
