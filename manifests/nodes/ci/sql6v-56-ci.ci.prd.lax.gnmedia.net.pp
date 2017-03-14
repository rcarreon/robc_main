node 'sql6v-56-ci.ci.prd.lax.gnmedia.net' {
    include base
    $project="ci"
#    include mysqld::server::ci_replcerts
    class {"mysqld56": template=>"56-ci.ci.prd.lax-slave"}

    common::nfsmount { "/sql/data":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql6v_56_ci_ci_prd_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql6v_56_ci_ci_prd_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ci_lax_prd_sql_log/sql6v-56-ci.ci.prd.lax.gnmedia.net",
    }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
