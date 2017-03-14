node 'sql1v-vipvisual.tp.dev.lax.gnmedia.net' {
    include base
        $project="admin"
        class {"mysqld56": template=>"vipvisual.tp.dev.lax-standalone", sqlclass=>"supported"}

        common::nfsmount { "/sql/data":
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql1v_vipvisual_tp_dev_lax_data",
        }

        common::nfsmount { "/sql/binlog":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_vipvisual_tp_dev_lax_binlog",
        }

        common::nfsmount { "/sql/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_sql_log/sql1v-vipvisual.tp.dev.lax.gnmedia.net",
        }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
