node 'sql1v-mstr.tp.prd.lax.gnmedia.net' {
    include base
    $project="admin"
    class {"mysqld56": template=>"56-mstr.tp.prd.lax-master"}

    common::nfsmount { "/sql/data":
        device  => "nfsA-netapp1.tp.prd.lax.gnmedia.net:/vol/nac1a_sql1v_mstr_tp_prd_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsA-netapp1.tp.prd.lax.gnmedia.net:/vol/nac1a_sql1v_mstr_tp_prd_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsA-netapp1.tp.prd.lax.gnmedia.net:/vol/nac1a_tp_lax_prd_sql_log/sql1v-mstr.tp.prd.lax.gnmedia.net",
    }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
