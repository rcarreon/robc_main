node 'app1v-vipvisual.tp.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="admin"
	include httpd
        include common::app
        include subversion::client
        include yum::mysql5527

        httpd::virtual_host {"vipvisual.gnmedia.net":}

        package { [ "python-sqlalchemy", "MySQL-python","python-cheetah","pysvn","python-lockfile","python-dns","mod_wsgi","mysql" ]:
            ensure => latest,
        }

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_app_shared/vipvisual-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_app_log/app1v-vipvisual.tp.dev.lax.gnmedia.net",
        }


        file {"/app/shared/vipvisual/sqlhostname":
             owner   => "root",
             group   => "root",
             mode    => 644,
             content => "sql1v-vipvisual.tp.dev.lax.gnmedia.net",
        }
        file {"/app/shared/vipvisual/sqlpassword":
             owner   => "root",
             group   => "root",
             mode    => 644,
             content => "Gw1Xdg3I",
        }

        cron { "vipvisual":
             ensure  => present,
             command => "/app/shared/vipvisual/cron_parse.py >> /app/shared/vipvisual/parser.log",
             user    => 'root',
             minute  => '*/5'
        }

}
