node 'app1v-rabbit.ap.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="adops"
    include common::app

    package { 'rabbitmq-server': ensure => installed }
    service { 'rabbitmq-server': ensure => running, enable => true }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_shared/rabbit-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_log/app1v-rabbit.ap.prd.lax.gnmedia.net",
    }
}
