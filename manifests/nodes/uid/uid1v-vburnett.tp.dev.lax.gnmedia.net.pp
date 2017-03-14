node 'uid1v-vburnett.tp.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="admin"
        include puppet_agent::uid
        include yum::postgres
        include auth::mysql
        class {"mysqld56": }

        common::nfsmount { "/sql/data":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_vburnett_tp_dev_lax_data",
        }

        common::nfsmount { "/sql/binlog":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_vburnett_tp_dev_lax_binlog",
        }

        common::nfsmount { "/sql/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_uid_log/uid1v-vburnett.tp.dev.lax.gnmedia.net",
        }
}
