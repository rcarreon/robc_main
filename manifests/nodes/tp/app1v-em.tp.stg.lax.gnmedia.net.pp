node 'app1v-em.tp.stg.lax.gnmedia.net' {
    include base
    include em
    include sendmail

    common::nfsmount {"/sql/binlog":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_app1v_em_tp_stg_lax_binlog",
    }

    common::nfsmount { "/sql/data":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_app1v_em_tp_stg_lax_data",
    }    

    common::nfsmount { "/sql/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_stg_sql_log/app1v-em.tp.stg.lax.gnmedia.net",
    }

    mysqld::server::v5527::install {"em.tp.stg.lax-standalone":}
    #nagios::service {"em_stage_monitoring_http": 
        #command => "check_url!stg.em.gnmedia.net!/!instances" 
    #}
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
