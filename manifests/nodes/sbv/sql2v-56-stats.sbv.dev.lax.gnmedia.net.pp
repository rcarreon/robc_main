node 'sql2v-56-stats.sbv.dev.lax.gnmedia.net' {
    include base
    $project="springboard"
    class {"mysqld56": template=>"56-stats.sbv.dev.lax-slave"}

    common::nfsmount { "/sql/data":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql2v_56_stats_sbv_dev_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql2v_56_stats_sbv_dev_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sbv_lax_dev_sql_log/sql2v-56-stats.sbv.dev.lax.gnmedia.net",
    }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
