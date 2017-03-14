node 'sql2v-api-cs.ao.prd.lax.gnmedia.net' {
    $project="api-cs"

    include base
    class {"mysqld56": template=>"api-cs.ao.prd.lax-master", sqlclass=>"supported"}

    common::nfsmount { "/sql/data":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql2v_api_cs_ao_prd_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql2v_api_cs_ao_prd_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_prd_sql_log/sql2v-api-cs.ao.prd.lax.gnmedia.net",
    }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
