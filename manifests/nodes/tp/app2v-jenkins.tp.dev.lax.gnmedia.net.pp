node 'app2v-jenkins.tp.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="admin"
    include common::app

    package { "rubygems":
        ensure => installed,
    }

    user { "apache":
        ensure  => present,
        uid     => '48',
        gid     => '48',
        home    => '/var/www',
        shell   => '/sbin/nologin',
        require => Group["apache"],
    }

    group { "apache":
        ensure => present,
        gid    => '48',
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_app_shared/jenkins-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_tp_lax_dev_app_log/app2v-jenkins.tp.dev.lax.gnmedia.net",
    }
}
