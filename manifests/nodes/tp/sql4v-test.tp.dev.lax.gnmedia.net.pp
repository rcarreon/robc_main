node 'sql4v-test.tp.dev.lax.gnmedia.net' {
    include base
    $project="admin"
    include mysqld::server::ci_replcerts
    class {"mysqld56": template=>"test-standalone", sqlclass=>"supported"}

    common::nfsmount { "/sql/data":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql4v_test_tp_dev_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql4v_test_tp_dev_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_tp_lax_dev_sql_log/sql4v-test.tp.dev.lax.gnmedia.net",
    }
}
