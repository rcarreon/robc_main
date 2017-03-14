node 'app7v-ci.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="admin"
        include common::app
        $at_silo="" # hosts module requires this parameter
        include mysqld::user

        class { 'php::install': version => '5.3', extra_packages => ['php53u-pecl-xdebug', 'php53u-pear', 'php53u-phpunit-PHPUnit', 'php53u-soap', 'php53u-pecl-memcached'] }

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_shared/ci-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_log/app7v-ci.tp.prd.lax.gnmedia.net",
        }
}
