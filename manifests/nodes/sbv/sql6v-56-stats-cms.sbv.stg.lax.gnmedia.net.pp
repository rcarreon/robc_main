node 'sql6v-56-stats-cms.sbv.stg.lax.gnmedia.net' {
    include base
    # include yum::mariadb::wildwest

    $project="springboard"
    # class {"mysqld56": template=>"56-stats-cms.sbv.stg.lax-slave"}

    common::nfsmount { "/sql/data":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql6v_56_stats_cms_sbv_stg_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql6v_56_stats_cms_sbv_stg_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sbv_lax_stg_sql_log/sql6v-56-stats-cms.sbv.stg.lax.gnmedia.net",
    }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
