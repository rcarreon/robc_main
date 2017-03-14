node 'uid1v-aarwine.sbv.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="springboard"
    class {"mysqld56": template=>"uid.sbv.dev.lax-standalone"}
    include common::app
    include httpd
    include php::cms

    # Deploy requirements
    $deployreqs = ['python-argparse', 'MySQL-python', 'python-gitdb', 'GitPython', 'python-paramiko']
    package { $deployreqs:
        ensure => installed,
    }

    package { 'git':
        ensure => installed,
    }

    httpd::virtual_host {'uid.cms.springboardplatform.com':}
    httpd::virtual_host {'uid.media.springboardplatform.com':}
    httpd::virtual_host {'00-uid.publishers.springboardplatform.com':}

    common::nfsmount { "/sql/data":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_aarwine_sbv_dev_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_aarwine_sbv_dev_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_dev_sql_log/uid1v-aarwine.sbv.dev.lax.gnmedia.net",
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_dev_uid_shared/aarwine-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_dev_app_log/uid1v-aarwine.sbv.dev.lax.gnmedia.net",
    }

    common::nfsmount { "/app/ugc":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sbv_lax_dev_app_ugc",
    }
}
