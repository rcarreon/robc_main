node 'app1v-stats-cms.sbv.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    include cms::stats::prod
    include ganglia::modules::sbv_stats
    include pythondeployer
    $project='springboard'

    httpd::virtual_host {'analytics.springboardvideo.com':
        expect => '[OK] APPLICATION HEALTHCHECK',
        uri    => '/healthcheck.php',
    }

    common::nfsmount { '/app/shared':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_prd_app_shared/stats_cms_shared',
    }

    common::nfsmount { '/app/log':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_prd_app_log/app1v-stats-cms.sbv.prd.lax.gnmedia.net',
    }

    package { 'subversion':
        ensure => installed,
    }

    $sbvGeoIPLicense=decrypt('L0K3qxm/4u6FIVQ5sNvETA==')
    $sbvGeoIPUserID='32923'
    $sbvGeoIPProductID='133'

    file { '/etc/GeoIP.conf':
        ensure  => present,
        content => "LicenseKey ${sbvGeoIPLicense}\nUserId ${sbvGeoIPUserID}\nProductIds ${sbvGeoIPProductID}\n",
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    cron { 'geoip':
        user    => 'deploy',
        minute  => '0',
        hour    => '12',
        weekday => '3',
        command => '/usr/bin/geoipupdate -f /etc/GeoIP.conf -d /app/shared/docroots/geoip/',
    }

}
