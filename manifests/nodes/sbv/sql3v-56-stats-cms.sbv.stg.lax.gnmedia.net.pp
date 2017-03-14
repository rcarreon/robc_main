node 'sql3v-56-stats-cms.sbv.stg.lax.gnmedia.net' {
    include base
    $project="springboard"
    class {"mysqld56": template=>"56-stats-cms.sbv.stg.lax-slave"}

    # added allow mysql to use a table with a lot of partitions (lots of files per client)
    class {'security::mysql_nofile':
                hard_file_limit => 32768,
                soft_file_limit => 24576,
    }

    common::nfsmount { "/sql/data":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql3v_56_stats_cms_sbv_stg_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql3v_56_stats_cms_sbv_stg_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sbv_lax_stg_sql_log/sql3v-56-stats-cms.sbv.stg.lax.gnmedia.net",
    }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
