node 'app2v-55-dh.si.dev.lax.gnmedia.net' {
    include base
    $project="doublehelix"
    include common::app
    include yum::ius
    include yum::ius::beta
    include yum::updates::beta
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
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

   file { '/app/shared/docroots/':
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0775',
    }   
    file { '/app/shared/docroots/flow.evolvemediallc.com/':
        ensure => directory,
        owner  => 'deploy',
        group  => 'apache',
        mode   => '0775',
    }   
    file { '/app/shared/docroots/flow.evolvemediallc.com/config':
        ensure => directory,
        owner  => 'deploy',
        group  => 'apache',
        mode   => '0550',
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_si_lax_dev_app_shared/55-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_si_lax_dev_app_log/app2v-55-dh.si.dev.lax.gnmedia.net",
    }
    common::nfsmount { "/app/tmp":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_si_lax_dev_app_tmp/app2v-55-dh.si.dev.lax.gnmedia.net",
    }
    common::nfsmount { "/app/ugc":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_si_lax_dev_app_ugc/dh-ugc",
    }

}
