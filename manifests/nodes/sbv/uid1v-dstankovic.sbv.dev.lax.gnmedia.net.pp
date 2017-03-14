node 'uid1v-dstankovic.sbv.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="springboard"
    class {"mysqld56": template=>"aarwine.sbv.dev.lax-standalone"}
    #mysqld::server::v5627::install {"aarwine.sbv.dev.lax-standalone":}
    include common::app
    include puppet_agent::uid
    include subversion::client
    include php::media
    include httpd
    include logrotate::sbv
    # Deploy requirements
    $deployreqs = ['python-argparse', 'MySQL-python', 'python-gitdb', 'GitPython', 'python-paramiko']
    package { $deployreqs:
        ensure => installed,
    }

    httpd::virtual_host {'uid.cms.springboardplatform.com':}
    httpd::virtual_host {'uid.media.springboardplatform.com':}
    httpd::virtual_host {'00-uid.publishers.springboardplatform.com':}

    package { "ffmpeg":
        ensure => present,
    }

    package { "php-pear":
        ensure => installed,
    }

    package { 'git':
        ensure => installed,
    }

    common::nfsmount { "/sql/data":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_dstankovic_sbv_dev_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_dstankovic_sbv_dev_lax_binlog",
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_dev_uid_shared/dstankovic-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_dev_uid_log/uid1v-dstankovic.sbv.dev.lax.gnmedia.net",
    }

    common::nfsmount { "/app/ugc":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sbv_lax_dev_app_ugc",
    }
    common::nfsmount { "/app/ugc_uid":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sbv_lax_uid_app_ugc",
    }

    mount { "/sql/log":
        ensure => "absent",
    }

    cron { "fetch_flv":
        command => "/usr/bin/php /app/shared/docroots/cms.springboard.gorillanation.com/htdocs/modules/fetch_flv_springboard/fetch_flv.php",
        user    => "apache",
        minute  => "*",
    }

    cron { "get_video":
        command => "/usr/bin/php /app/shared/docroots/cms.springboard.gorillanation.com/htdocs/modules/encoding/get_video.php",
        user    => "apache",
        minute  => "*",
    }

    cron { "dashboard_cron":
        command => "/usr/bin/php /app/shared/docroots/cms.springboard.gorillanation.com/htdocs/modules/fetch_flv_springboard/dashboard_cron.php",
        user    => "apache",
        minute  => "0",
        hour    => "0",
    }

}
