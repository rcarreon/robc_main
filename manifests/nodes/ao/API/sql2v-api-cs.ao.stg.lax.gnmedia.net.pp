node 'sql2v-api-cs.ao.stg.lax.gnmedia.net' {
    $project="api-cs"

    include base
    class {"mysqld56": template=>"api-cs.ao.stg.lax-master", sqlclass=>"supported"}

    common::nfsmount { "/sql/data":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql2v_api_cs_ao_stg_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql2v_api_cs_ao_stg_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_stg_sql_log/sql2v-api-cs.ao.stg.lax.gnmedia.net",
    }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
