node 'app7v-puppet.tp.prd.lax.gnmedia.net' {
    include base
    $project="puppet"
    $httpd="puppet"
    include common::app
    include puppet_master_27

    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_shared/puppet27-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_log/app7v-puppet.tp.prd.lax.gnmedia.net",
    }
}
