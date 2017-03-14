node 'sql3v-56-wp.ao.stg.lax.gnmedia.net' {
    include base
    $project="atomiconline"
    class {"mysqld56": template=>"56-wp.ao.stg.lax-slave", sqlclass=>"supported"}

    common::nfsmount { "/sql/data":
        device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql3v_56_wp_ao_stg_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql3v_56_wp_ao_stg_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_sql_log/sql3v-56-wp.ao.stg.lax.gnmedia.net",
    }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
