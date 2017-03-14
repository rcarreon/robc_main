node 'uid1v-mjovanovic.sbv.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="springboard"
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

    package { "git":
        ensure => present,
    }



    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_dev_uid_shared/mjovanovic-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_dev_app_log/uid1v-mjovanovic.sbv.dev.lax.gnmedia.net",
    }

    common::nfsmount { "/app/ugc":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sbv_lax_dev_app_ugc",
    }
    common::nfsmount { "/app/ugc_uid":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sbv_lax_uid_app_ugc",
    }
}
