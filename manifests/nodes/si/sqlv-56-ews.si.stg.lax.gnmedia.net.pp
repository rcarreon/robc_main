node 'sqlv-56-ews.si.stg.lax.gnmedia.net' {
    include base
    $project="si"
    class {"mysqld56": template=>"56-ews.si.stg.lax-master"}

    common::nfsmount { "/sql/data":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sqlv_56_ews_si_stg_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sqlv_56_ews_si_stg_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_si_lax_stg_sql_log/sqlv-56-ews.si.stg.lax.gnmedia.net",
    }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
