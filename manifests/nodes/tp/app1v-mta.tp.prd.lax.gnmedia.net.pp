node 'app1v-mta.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $ext_hostname="mta1.gnmedia.net"
    include postfix::gateway
    $project="admin"
    include common::app
    include rsyslog::postfix_gateway
    include nagios::postfix_gateway

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_shared/mta-shared/app1v-mta.tp.prd.lax.gnmedia.net",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_log/app1v-mta.tp.prd.lax.gnmedia.net",
    }

}