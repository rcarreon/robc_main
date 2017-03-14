node 'sql1v-bi-reports.ap.dev.lax.gnmedia.net' {
    include base
    $project="adops"

    class {"mysqld56": template=>"bi-reports.ap.dev.lax-standalone", sqlclass=>"supported"}

    common::nfsmount { "/sql/data":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_bi_reports_ap_dev_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_bi_reports_ap_dev_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_dev_sql_log/sql1v-bi-reports.ap.dev.lax.gnmedia.net",
    }
    
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
