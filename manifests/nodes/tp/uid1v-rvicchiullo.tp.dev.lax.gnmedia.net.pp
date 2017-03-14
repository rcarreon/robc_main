node 'uid1v-rvicchiullo.tp.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="admin"
    include sendmail::use_gateway
    include yum::ius
    include php::si_54
    include yum::mysql5627

    common::nfsmount { "/app/log/app1v-mta_log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_log/app1v-mta.tp.prd.lax.gnmedia.net",
    }
}
