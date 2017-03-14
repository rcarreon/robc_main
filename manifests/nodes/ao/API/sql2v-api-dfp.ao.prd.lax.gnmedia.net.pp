node 'sql2v-api-dfp.ao.prd.lax.gnmedia.net' {
        $project="api-dfp"
        
        include base
        class {"mysqld56": template=>"api-dfp.ao.prd.lax-master", sqlclass=>"supported"}

        common::nfsmount { "/sql/data":
                device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql2v_api_dfp_ao_prd_lax_data",
        }

        common::nfsmount { "/sql/binlog":
                device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql2v_api_dfp_ao_prd_lax_binlog",
        }

        common::nfsmount { "/sql/log":
                device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_sql_log/sql2v-api-dfp.ao.prd.lax.gnmedia.net",
        }
        include newrelic
        include newrelic::params
        include newrelic::sysmond
        include newrelic::nfsiostat
        include newrelic::mysql
}
