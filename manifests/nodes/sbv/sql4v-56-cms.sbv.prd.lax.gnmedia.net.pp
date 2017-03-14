node 'sql4v-56-cms.sbv.prd.lax.gnmedia.net' {
    include base
    $project="springboard"
    class {"mysqld56": template=>"56-cms.sbv.prd.lax-slave"}

    common::nfsmount { "/sql/data":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql4v_56_cms_sbv_prd_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql4v_56_cms_sbv_prd_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sbv_lax_prd_sql_log/sql4v-56-cms.sbv.prd.lax.gnmedia.net",
    }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
