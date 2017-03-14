node 'app1v-sploit.og.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="origin"
    include common::app

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_dev_app_shared/sploit-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_dev_app_log/app1v-sploit.og.dev.lax.gnmedia.net",
    }

    common::nfsmount { "/app/software":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_dev_app_shared/sploit-software",
    }
}
