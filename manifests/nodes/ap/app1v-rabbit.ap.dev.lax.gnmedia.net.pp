node 'app1v-rabbit.ap.dev.lax.gnmedia.net' {
    include base
    $project="adops"
    include common::app
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat

    package { 'rabbitmq-server': ensure => installed }
    service { 'rabbitmq-server': ensure => running, enable => true }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/rabbit-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_log/app1v-rabbit.ap.dev.lax.gnmedia.net",
    }
}
