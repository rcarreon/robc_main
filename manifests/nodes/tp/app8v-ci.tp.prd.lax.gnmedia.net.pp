node 'app8v-ci.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $at_silo="" # hosts module requires this parameter

    $env="uid"
    $httpd="crowdignite"
    $project="crowdignite"
    include common::app
    include jenkins::centos6client

    $phpenv="uid" # allows for function proc_open in php.ini
    $php_version="5.3.14"
    include common::app
    include sysctl
    include subversion::client
    include php::browscap
    include logrotate::crowdignite_cakephp
    include ganglia::modules::mod_sflow
    include yum::ius
    include php::ius
    include php::ius::memcached
    include php::ius::imagick


    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_shared/ci-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_tp_lax_prd_app_log/app8v-ci.tp.prd.lax.gnmedia.net",
    }

}
