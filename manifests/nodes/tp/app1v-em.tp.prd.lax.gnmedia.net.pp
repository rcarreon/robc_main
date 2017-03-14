node 'app1v-em.tp.prd.lax.gnmedia.net' {
    include base
    $project="admin"
    include em
    include sendmail
    include sendmail::use_gateway

    common::nfsmount { "/sql/binlog":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_app1v_em_tp_prd_lax_binlog",
    }

    common::nfsmount { "/sql/data":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_app1v_em_tp_prd_lax_data",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_sql_log/app1v-em.tp.prd.lax.gnmedia.net",
    }

    mysqld::server::v5527::install {"em.tp.prd.lax-standalone":}

# Enable once DBA team has MySQL EM up and running
#  nagios::service {"em_monitoring_http":
#    command => "check_url!em.gnmedia.net!/!instances"
#  }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
