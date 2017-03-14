node 'sql1v-em.tp.dev.lax.gnmedia.net' {
    include base

    common::nfsmount { "/sql/binlog":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_em_tp_dev_lax_binlog",
        options => "nfsvers=3,tcp,noatime,rw,rsize=32768,wsize=32768,hard,intr,tcp",
    }

    common::nfsmount { "/sql/data":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_em_tp_dev_lax_data",
        options => "nfsvers=3,tcp,noatime,rw,rsize=32768,wsize=32768,hard,intr,tcp",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_sql_log/sql1v-em.tp.dev.lax.gnmedia.net",
        options => "nfsvers=3,tcp,noatime,rw,rsize=32768,wsize=32768,hard,intr,tcp",
    }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
