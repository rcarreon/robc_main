node 'uid1v-atodorovic.sbv.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="springboard"
        class {"mysqld56": template=>"uid.sbv.dev.lax-standalone"}
        include common::app
        include httpd
        include php
        include puppet_agent::uid
        include logrotate::sbv
        $packages_X = ['git', "java-1.6.0-openjdk", "firefox", "xorg-x11-server-Xvfb", "xorg-x11-server-Xorg" ]

        package { $packages_X :
            ensure => installed,
        }

        # Deploy requirements
        $deployreqs = ['python-argparse', 'MySQL-python', 'python-gitdb', 'GitPython', 'python-paramiko']
        package { $deployreqs:
                ensure => installed,
        }

        # start/stop xvfb script
        file {"/etc/init.d/xvfb":
            require => Package["xorg-x11-server-Xvfb"],
            source  => "puppet:///modules/jenkins/init_xvfb",
            owner   => "deploy",
            group   => "deploy",
            mode    => 755,
        }

        # xvfb and vnc requires a running font server , this service is not in the server
#        service { "xfs":
#           ensure => running,
#        }

        # for monit, ensure xvfb is running
        include monit::xvfb

        common::nfsmount { "/sql/data":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_atodorovic_sbv_dev_lax_data",
        }

        common::nfsmount { "/sql/binlog":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_atodorovic_sbv_dev_lax_binlog",
        }

        common::nfsmount { "/sql/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_dev_uid_log/uid1v-atodorovic.sbv.dev.lax.gnmedia.net",
        }

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_dev_uid_shared/atodorovic-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_dev_uid_log/uid1v-atodorovic.sbv.dev.lax.gnmedia.net",
        }

        common::nfsmount { "/app/ugc_uid":
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sbv_lax_uid_app_ugc",
        }
        common::nfsmount { "/app/ugc":
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sbv_lax_dev_app_ugc",
        }
}
