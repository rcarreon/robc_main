node 'sql1v-56-dw.ci.prd.lax.gnmedia.net' {
    include base
    $project="ci"
    class {"mysqld56": template=>"56-dw.ci.prd.lax-master"}

    # added allow mysql to use a table with a lot of partitions (lots of files per client)
    class {'security::mysql_nofile':
                hard_file_limit => 32768,
                soft_file_limit => 24576,
    }

    common::nfsmount { "/sql/data":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_56_dw_ci_prd_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_56_dw_ci_prd_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ci_lax_prd_sql_log/sql1v-56-dw.ci.prd.lax.gnmedia.net",
    }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
