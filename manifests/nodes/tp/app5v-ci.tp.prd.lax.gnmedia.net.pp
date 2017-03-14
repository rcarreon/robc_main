node 'app5v-ci.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $at_silo="" # hosts module requires this parameter
        $project="admin"
        include common::app
        include jenkins::centos6client
        include mysqld::user
        include memcached

        package { ["php-pecl-xdebug","java-1.6.0-openjdk-devel"]:
            ensure => present,
        }

        package { "python-phabricator":
            ensure => present,
        }

        package { [ 'python-freshen', 'python-nose1.3', 'mysql-connector-python', 'MySQL-python', 'python-argparse', 'python-apscheduler', 'python-sqlalchemy']:
            ensure => present,
        }

        package {"php-channel-phpunit": ensure => installed,}
        package {"php-phpunit-PHPUnit": ensure => installed,}

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_shared/ci-shared",
        }

        common::nfsmount { "/app/log":
		device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_log/app5v-ci.tp.prd.lax.gnmedia.net"
        }
}
