node 'sql2v-api-dfp.ao.stg.lax.gnmedia.net' {
        $project="api-dfp"
        
        include base
        class {"mysqld56": template=>"api-dfp.ao.stg.lax-master", sqlclass=>"supported"}

        common::nfsmount { "/sql/data":
                device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql2v_api_dfp_ao_stg_lax_data",
        }

        common::nfsmount { "/sql/binlog":
                device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql2v_api_dfp_ao_stg_lax_binlog",
        }

        common::nfsmount { "/sql/log":
                device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_sql_log/sql2v-api-dfp.ao.stg.lax.gnmedia.net",
        }
        include newrelic
        include newrelic::params
        include newrelic::sysmond
        include newrelic::nfsiostat
        include newrelic::mysql
}
