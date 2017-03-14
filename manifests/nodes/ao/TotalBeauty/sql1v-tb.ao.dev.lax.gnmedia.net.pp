node 'sql1v-tb.ao.dev.lax.gnmedia.net' {
    $project='atomiconline'
    include base
    class {"mysqld56": template=>"56-tb.ao.dev.lax-standalone", sqlclass=>"supported"}


    common::nfsmount { '/sql/log':
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_tb_ao_dev_lax_log",
    }

    common::nfsmount { '/sql/binlog':
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_tb_ao_dev_lax_binlog",
    }

    common::nfsmount { '/sql/data':
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_tb_ao_dev_lax_data",
    }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
