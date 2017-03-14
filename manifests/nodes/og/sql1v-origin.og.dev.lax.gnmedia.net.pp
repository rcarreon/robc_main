node 'sql1v-origin.og.dev.lax.gnmedia.net' {
    include base
    $project="origin"
    include auth::mysql
    class {'mysqld56': template=>'origin.og.dev-standalone', sqlclass=>'supported'}

    common::nfsmount { "/sql/data":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_origin_og_dev_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_origin_og_dev_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_dev_sql_log/sql1v-origin.og.dev.lax.gnmedia.net",
    }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
