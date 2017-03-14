node 'app1v-tags.ap.dev.lax.gnmedia.net' {
    include base
    include ap::app::tags
    include ap::app::tags::dev

    include newrelic
    include newrelic::params
    include newrelic::nfsiostat
    include newrelic::sysmond

    include pipestash

    $project='adops'
    httpd::virtual_host {"dev.tags.evolvemediallc.com": monitor => false}

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/tags-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_log/app1v-tags.ap.dev.lax.gnmedia.net",
    }
}
