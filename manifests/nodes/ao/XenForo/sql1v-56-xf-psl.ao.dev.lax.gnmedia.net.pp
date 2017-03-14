node 'sql1v-56-xf-psl.ao.dev.lax.gnmedia.net' {
    include base
    $project="atomiconline"
    class {"mysqld56": template=>"56-xf-psl.ao.dev.lax-master", sqlclass=>"supported"}

    common::nfsmount { "/sql/data":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_56_xf_psl_ao_dev_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_56_xf_psl_ao_dev_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_sql_log/sql1v-56-xf-psl.ao.dev.lax.gnmedia.net",
    }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
