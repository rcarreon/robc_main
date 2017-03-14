node 'sql2v-56-vb-wz.ao.prd.lax.gnmedia.net' {
    include base
    $project="atomiconline"

    class {"mysqld56": template=>"56-vb-wz.ao.prd.lax-master", sqlclass=>"supported"}

    common::nfsmount { "/sql/data":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql2v_56_vb_wz_ao_prd_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql2v_56_vb_wz_ao_prd_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_prd_sql_log/sql2v-56-vb-wz.ao.prd.lax.gnmedia.net"
    }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
