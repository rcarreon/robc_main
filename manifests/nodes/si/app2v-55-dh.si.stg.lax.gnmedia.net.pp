node 'app2v-55-dh.si.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="doublehelix"
    include common::app
    include yum::ius
    include yum::updates::beta
    include yum::ius::beta
    include monit::laravel_si
    package { ['php55u',
               'php55u-cli',
               'php55u-common',
               'php55u-mcrypt',
               'php55u-mysqlnd',
               'php55u-gd',
               'php55u-gmp',
               'php55u-intl',
               'php55u-pear',
               'php55u-pecl-imagick',
               'php55u-pecl-memcache'
              ]:
        ensure => installed, 
    }
    include httpd
    httpd::virtual_host {"flow.evolvemediallc.com":}
    httpd::virtual_host {"showcase.evolvemediallc.com":}


    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_si_lax_stg_app_shared/55-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_si_lax_stg_app_log/app2v-55-dh.si.stg.lax.gnmedia.net",
    }

    common::nfsmount { "/app/tmp":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_si_lax_stg_app_tmp/app2v-55-dh.si.stg.lax.gnmedia.net",
    }

    common::nfsmount { "/app/ugc":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_si_lax_stg_app_ugc/dh-ugc",
    }
}
