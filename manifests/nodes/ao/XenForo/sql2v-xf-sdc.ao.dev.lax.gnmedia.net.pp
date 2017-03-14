node 'sql2v-xf-sdc.ao.dev.lax.gnmedia.net' {
    include base
    $project="atomiconline"
    class {"mysqld56": template=>"xf-sdc.ao.dev.lax-master", sqlclass=>"supported"}

    common::nfsmount { "/sql/data":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql2v_xf_sdc_ao_dev_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql2v_xf_sdc_ao_dev_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_dev_sql_log/sql2v-xf-sdc.ao.dev.lax.gnmedia.net",
    }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
