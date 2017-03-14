node 'app1v-55-dh.si.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="doublehelix"
    include common::app
    include yum::ius
    include yum::ius::beta
    include yum::updates::beta
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
    file { '/app/shared/docroots/flow.evolvemediallc.com/config/env.php':
        ensure  => present,
        owner   => 'deploy',
        group   => 'apache',
        mode    => '0550',
        require => File['/app/shared/docroots/flow.evolvemediallc.com/config'],
        content => decrypt('xhYcoLSCsuVWW9gikGeWXeqekhTBUh5UvTErsDhwKvG3zdi6bigGwS3VYZJy214qtJWBfn7qvMWfSAHeGvGjXyD9kypRoK6hGGoZX+Rz12f9ZMRjJYBgmv7KWsVMF1u2GrX0B870AvwWn2XW9rft4oZCxGI1dzXtYnLououBjX2+KPBQup/gYGRGBOliXJ6jjmXmfz/bFFQu8Do6dOIV0AYAc2MDroEeym+M2sLt70dKNqtGZ23Yo7Gk2xxc3gE6rc0'),
    }

    file { '/app/shared/docroots/showcase.evolvemediallc.com/':
        ensure => directory,
        owner  => 'deploy',
        group  => 'apache',
        mode   => '0775',
    }
    file { '/app/shared/docroots/showcase.evolvemediallc.com/config':
        ensure => directory,
        owner  => 'deploy',
        group  => 'apache',
        mode   => '0550',
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_si_lax_stg_app_shared/55-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_si_lax_stg_app_log/app1v-55-dh.si.stg.lax.gnmedia.net",
    }

    common::nfsmount { "/app/tmp":
            device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_si_lax_stg_app_tmp/app1v-55-dh.si.stg.lax.gnmedia.net",
    }

    common::nfsmount { "/app/ugc":
            device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_si_lax_stg_app_ugc/dh-ugc",
    }

}
