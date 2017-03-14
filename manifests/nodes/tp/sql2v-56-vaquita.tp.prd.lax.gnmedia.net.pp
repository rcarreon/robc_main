node 'sql2v-56-vaquita.tp.prd.lax.gnmedia.net' {
    include base
    $project="admin"
    class {"mysqld56": template=>"56-vaquita.tp.prd.lax-master"}

    package { [
        'percona-toolkit'
        ]:
        ensure => installed,
    }

    common::nfsmount { "/sql/data":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql2v_56_vaquita_tp_prd_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql2v_56_vaquita_tp_prd_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_tp_lax_prd_sql_log/sql2v-56-vaquita.tp.prd.lax.gnmedia.net",
    }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
