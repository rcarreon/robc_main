node 'app1v-build.si.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="build"
    include common::app
    include git::client
    include subversion::client
    include php::si_54
    include logrotate::si_build
    include deploy_si
    include yum::mysql5527

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_si_lax_dev_app_shared/build-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_si_lax_dev_app_log/app1v-build.si.dev.lax.gnmedia.net",
    }


    # Ensure composer executable is available in path
    file { '/usr/local/bin/composer':
       ensure   => 'link',
       target   => '/app/shared/bin/composer',
       require  => Mount['/app/shared'],
    }

    file { ['/app/shared/migrations-checkout',
            '/app/shared/migrations-checkout/configs/si_app_flow.evolvemediallc.com']:
        ensure  => directory,
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0700',
        require => Common::Nfsmount['/app/shared'],
    }

    file { '/app/shared/migrations-checkout/configs/si_app_flow.evolvemediallc.com/flow_w.env.prd.php':
        ensure  => present,
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0700',
        content => decrypt('xhYcoLSCsuVWW9gikGeWXeqekhTBUh5UvTErsDhwKvG3zdi6bigGwS3VYZJy214q9JwIknYiPjd8lGO2woHg2DYvcn1oWUZVID/Pk8KE82qi7iAhfhtWw9GR6Op/ypFCj5tkWYauGorOJ4IrMQz/hIRzic8XBFLU/eATCDQ8m8DRjy+j2oZgEoSPhwgiMQh5PnosnULhtrIpQZFxDewTD5qMewpDX1MXTMxTOEfoQryOkNWxIYsJrSs/GYa3qU3O'),
        require => File['/app/shared/migrations-checkout/configs/si_app_flow.evolvemediallc.com'],
    }

    file { '/app/shared/migrations-checkout/configs/si_app_flow.evolvemediallc.com/flow_admin.env.prd.php':
        ensure  => present,
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0700',
        content => decrypt('xhYcoLSCsuVWW9gikGeWXeqekhTBUh5UvTErsDhwKvG3zdi6bigGwS3VYZJy214q9JwIknYiPjd8lGO2woHg2DYvcn1oWUZVID/Pk8KE82qi7iAhfhtWw9GR6Op/ypFCj5tkWYauGorOJ4IrMQz/hIRzic8XBFLU/eATCDQ8m8AYjup/t04nkTXkhexFUYQBaBBzC8BrCWc1nPv7rGkUny0EGCBPLCGPv3GSsNqehkMBLh1rHrjuLhEiot8Yr9g1'),
        require => File['/app/shared/migrations-checkout/configs/si_app_flow.evolvemediallc.com'],
    }

    file { '/app/shared/migrations-checkout/configs/si_app_flow.evolvemediallc.com/flow_admin.env.stg.php':
        ensure  => present,
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0700',
        content => decrypt('xhYcoLSCsuVWW9gikGeWXeqekhTBUh5UvTErsDhwKvG3zdi6bigGwS3VYZJy214qtJWBfn7qvMWfSAHeGvGjXyD9kypRoK6hGGoZX+Rz12f9ZMRjJYBgmv7KWsVMF1u2GrX0B870AvwWn2XW9rft4oZCxGI1dzXtYnLououBjX3R00QdGiv3hRiqch1QKOfMnnSvwe72eHoJI0NC/A64SEHmxvcyXQT3JVRJfFy1EFkSbjrc7MwL/XaKei6eLzkSrc0'),
        require => File['/app/shared/migrations-checkout/configs/si_app_flow.evolvemediallc.com'],
    }

    file { '/app/shared/migrations-checkout/configs/si_app_flow.evolvemediallc.com/flow_admin.env.dev.php':
        ensure  => present,
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0700',
        content => decrypt('xhYcoLSCsuVWW9gikGeWXeqekhTBUh5UvTErsDhwKvGmsYdTyQQAbFoPbOKRsmA6dEjIq2v9mCFZYZbail3nmWc6EdSNa04qt9opkGEeb9Yz/fIbKPqRBVBit9bHvLKZlCE73SruofchWrkOA5lkgb4BYcVPAZkvsdge6xHUqJYxFQOB4hxVpZvN+BZ99b1LDoavMNz/axWQc0xQ4cCqsJTz5y+DRaX5oilgPBtip+ioUyAqUAyRAV1gxjYyxHNehTDJRs0phCNvwFWAySi/2bUDN+uUS++cpSOzUnCcPKk='),
        require => File['/app/shared/migrations-checkout/configs/si_app_flow.evolvemediallc.com'],
    }

    file { '/app/shared/migrations-checkout/configs/si_app_flow.evolvemediallc.com/flow_w.env.stg.php':
        ensure  => present,
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0700',
        content => decrypt('xhYcoLSCsuVWW9gikGeWXeqekhTBUh5UvTErsDhwKvG3zdi6bigGwS3VYZJy214qtJWBfn7qvMWfSAHeGvGjXyD9kypRoK6hGGoZX+Rz12f9ZMRjJYBgmv7KWsVMF1u2GrX0B870AvwWn2XW9rft4oZCxGI1dzXtYnLououBjX2+KPBQup/gYGRGBOliXJ6jjmXmfz/bFFQu8Do6dOIV0AYAc2MDroEeym+M2sLt70dKNqtGZ23Yo7Gk2xxc3gE6rc0'),
        require => File['/app/shared/migrations-checkout/configs/si_app_flow.evolvemediallc.com'],
    }

    # Ensure top level mount dirs have desired perms

    $sibuild_mount_dirs = [ "/mnt/dev", "/mnt/stg", "/mnt/prd", ]

    file { $sibuild_mount_dirs:
        ensure => 'directory',
        owner  => 'root',
        group  => 'deploy',
        mode   => '0750',
    }

    # Mount app-shared for dev, stg, prd

    common::nfsmount { "/mnt/dev/app-shared":
        device  => "nfsA-netapp1.si.dev.lax.gnmedia.net:/vol/nac1a_si_lax_dev_app_shared",
    }

    common::nfsmount { "/mnt/stg/app-shared":
        device  => "nfsA-netapp1.si.stg.lax.gnmedia.net:/vol/nac1a_si_lax_stg_app_shared",
    }

    common::nfsmount { "/mnt/prd/app-shared":
        device  => "nfsA-netapp1.si.prd.lax.gnmedia.net:/vol/nac1a_si_lax_prd_app_shared",
    }


    # Mount app-tmp for dev, stg, prd

    common::nfsmount { "/mnt/dev/app-tmp":
        device  => "nfsB-netapp1.si.dev.lax.gnmedia.net:/vol/nac1b_si_lax_dev_app_tmp",
    }

    common::nfsmount { "/mnt/stg/app-tmp":
        device  => "nfsB-netapp1.si.stg.lax.gnmedia.net:/vol/nac1b_si_lax_stg_app_tmp",
    }

    common::nfsmount { "/mnt/prd/app-tmp":
        device  => "nfsB-netapp1.si.prd.lax.gnmedia.net:/vol/nac1b_si_lax_prd_app_tmp",
    }


    # Mount app-ugc for dev, stg, prd

    common::nfsmount { "/mnt/dev/app-ugc":
        device  => "nfsB-netapp1.si.dev.lax.gnmedia.net:/vol/nac1b_si_lax_dev_app_ugc",
    }

    common::nfsmount { "/mnt/stg/app-ugc":
        device  => "nfsB-netapp1.si.stg.lax.gnmedia.net:/vol/nac1b_si_lax_stg_app_ugc",
    }

    common::nfsmount { "/mnt/prd/app-ugc":
        device  => "nfsB-netapp1.si.prd.lax.gnmedia.net:/vol/nac1b_si_lax_prd_app_ugc",
    }



}
