node 'sql2v-56-sdc.ao.stg.lax.gnmedia.net' {
    $project='atomiconline'
    include base
    class {"mysqld56": template=>"56-sdc.ao.stg.lax-master", sqlclass=>"supported"}


    common::nfsmount { '/sql/log':
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_stg_sql_log/sql2v-56-sdc.ao.stg.lax.gnmedia.net",
    }

    common::nfsmount { '/sql/binlog':
      device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql2v_56_sdc_ao_stg_lax_binlog",
    }

    common::nfsmount { '/sql/data':
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql2v_56_sdc_ao_stg_lax_data",
    }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
