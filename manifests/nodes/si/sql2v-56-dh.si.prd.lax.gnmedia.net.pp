node 'sql2v-56-dh.si.prd.lax.gnmedia.net' {
    include base
    $project="56"
    class {"mysqld56": template=>"56-dh.si.prd.lax-master"}

    # added allow mysql to use a table with a lot of partitions (lots of files per client)
    class {'security::mysql_nofile':
                hard_file_limit => 32768,
                soft_file_limit => 24576,
    }

    common::nfsmount { "/sql/data":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql2v_56_dh_si_prd_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql2v_56_dh_si_prd_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_si_lax_prd_sql_log/sql2v-56-dh.si.prd.lax.gnmedia.net",
    }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
