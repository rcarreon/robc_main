node 'sql1v-api-dfp.ao.dev.lax.gnmedia.net' {
        $project="api-dfp"
        
        include base
        class {"mysqld56": template=>"api-dfp.ao.dev.lax-standalone", sqlclass=>"supported"}

        common::nfsmount { "/sql/data":
                device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_api_dfp_ao_dev_lax_data",
        }

        common::nfsmount { "/sql/binlog":
                device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_api_dfp_ao_dev_lax_binlog",
        }

        common::nfsmount { "/sql/log":
                device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_sql_log/sql1v-api-dfp.ao.dev.lax.gnmedia.net",
        }
        include newrelic
        include newrelic::params
        include newrelic::sysmond
        include newrelic::nfsiostat
        include newrelic::mysql
}
