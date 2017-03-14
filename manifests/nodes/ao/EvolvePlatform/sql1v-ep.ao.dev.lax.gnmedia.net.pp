node 'sql1v-ep.ao.dev.lax.gnmedia.net' {
    $project="ep"

    include base
    class {"mysqld56": template=>"ep.ao.dev.lax-standalone", sqlclass=>"supported"}

    common::nfsmount { "/sql/data":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_ep_ao_dev_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_ep_ao_dev_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_sql_log/sql1v-ep.ao.dev.lax.gnmedia.net",
    }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
