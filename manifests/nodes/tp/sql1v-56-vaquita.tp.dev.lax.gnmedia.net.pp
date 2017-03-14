node 'sql1v-56-vaquita.tp.dev.lax.gnmedia.net' {
    include base
    $project="admin"
    class {"mysqld56": template=>"56-vaquita.tp.dev.lax-standalone"}

    package { [
        'percona-toolkit'
        ]:
        ensure => installed,
    }

    common::nfsmount { "/sql/data":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_56_vaquita_tp_dev_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_56_vaquita_tp_dev_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_tp_lax_dev_sql_log/sql1v-56-vaquita.tp.dev.lax.gnmedia.net",
    }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
