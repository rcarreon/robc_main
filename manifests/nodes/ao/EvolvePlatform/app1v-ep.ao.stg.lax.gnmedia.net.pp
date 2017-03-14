node 'app1v-ep.ao.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base

    $username="deploy"
    $project="atomiconline"
    $httpd="atomiconline"
    include ao::ep
    include ao::ep::stg_configs
    include yum::ius

    cron { 'cron_update_reports':
        ensure  => 'present',
        user    => 'root',
        minute  => 50,
        hour    => 4,
        command => '/usr/bin/php /app/shared/ep/dashboard/current/cron_update_reports.php',
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_shared/ep-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_log/app1v-ep.ao.stg.lax.gnmedia.net",
    }
}
