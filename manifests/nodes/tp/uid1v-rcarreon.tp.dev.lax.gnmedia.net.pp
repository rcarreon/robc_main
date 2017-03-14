node 'uid1v-rcarreon.tp.dev.lax.gnmedia.net' {
    include base
    $project="admin"
    include common::app
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat


    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_uid_shared/rcarreon-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_app_log/uid1v-rcarreon.tp.dev.lax.gnmedia.net",
    }
}
