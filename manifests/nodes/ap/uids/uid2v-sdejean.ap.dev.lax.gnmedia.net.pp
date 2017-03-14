node 'uid2v-sdejean.ap.dev.lax.gnmedia.net' {
    include base
    $project="adops"
    include adops::packages
    include adops::rbenv
    include adops::uid
    include php::adops
    include sendmail::tarpit
    include yum::adopsext::wildwest

    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat

    package { [
        'bash-completion',
        'ruby-devel',
        'gcc',
        'percona-toolkit'
        ]:
        ensure => installed,
    }

    common::nfsmount { "/sql/data":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid2v_sdejean_ap_dev_lax_data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid2v_sdejean_ap_dev_lax_binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_uid_log/uid2v-sdejean.ap.dev.lax.gnmedia.net",
    }

    common::nfsromount { "/app/software":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/ap-software-dev",
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_uid_shared/sdejean-shared",
    }

}
