node 'app2v-ldap.tp.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="admin"
    include common::app
    include ldap::server

    package {"nsscache": ensure=>present }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_app_shared/ldap-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_app_log/app2v-ldap.tp.dev.lax.gnmedia.net",
    }

    common::nfsmount { "/ldap_backup":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_tp_lax_prd_app_archive",
        options => "nfsvers=3,noatime,ro,rsize=32768,wsize=32768,hard,intr,tcp",
    }

}

