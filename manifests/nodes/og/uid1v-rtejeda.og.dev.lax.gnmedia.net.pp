node 'uid1v-rtejeda.og.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="origin"
    $httpd='origin'
    include common::app
    include origin::uid

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_dev_uid_shared/rtejeda-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_dev_app_log/uid1v-rtejeda.og.dev.lax.gnmedia.net",
    }

    common::nfsmount { "/app/ugc":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_dev_app_ugc",
    }

}
