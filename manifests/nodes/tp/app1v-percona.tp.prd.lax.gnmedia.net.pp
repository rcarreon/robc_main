node 'app1v-percona.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="admin"
#    include common::app
    sudo::install_template { 'dba-root': }
    include db_checksum
    include mysqld56::client
    
    package { "tmux":
        ensure => installed
    }

    # /app/log must be writeable for apache group (we have some cron using that group)
    file { "/app":
        ensure => directory,
        owner  => root,
        group  => root,
        mode   => 664,
    }

    file { "/app/log":
        ensure  => directory,
        owner   => root,
        group   => mysql,
        mode    => 775,
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_shared/percona-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_log/app1v-percona.tp.prd.lax.gnmedia.net",
    }

    package { ["percona-toolkit","perl-IO-Socket-SSL","perl-Net-LibIDN","perl-Net-SSLeay","mysql-connector-python","perl-Time-Piece"]:
        ensure => installed,
    }

}
