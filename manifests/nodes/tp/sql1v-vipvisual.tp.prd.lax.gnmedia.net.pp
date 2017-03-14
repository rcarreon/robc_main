node 'sql1v-vipvisual.tp.prd.lax.gnmedia.net' {
    include base
        $project="admin"
        class {"mysqld56": template=>"vipvisual.tp.prd.lax-standalone", sqlclass=>"supported"}


        common::nfsmount { "/sql/data":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_vipvisual_tp_prd_lax_data",
        }

        common::nfsmount { "/sql/binlog":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_vipvisual_tp_prd_lax_binlog",
        }

        common::nfsmount { "/sql/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_sql_log/sql1v-vipvisual.tp.prd.lax.gnmedia.net",
        }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
