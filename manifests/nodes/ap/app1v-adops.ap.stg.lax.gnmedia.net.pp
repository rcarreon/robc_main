node 'app1v-adops.ap.stg.lax.gnmedia.net' {
    include base
    $project='adops'
    include adops::packages
    include adops::packages::v3
    include adops::rbenv
    include adops::passenger4
    include adopsV3::appdirs
    include adops::devmail

    include adops::newrelic::apm

    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat

    include pipestash

    class { 'php::adops_memcache':
        memcache_servers => ['mem1v-adops.ap.stg.lax.gnmedia.net','mem2v-adops.ap.stg.lax.gnmedia.net']
    }

    file {'/etc/httpd/conf.d/passenger-adops.conf':
      ensure => absent
    }

    file {'/etc/httpd/conf.d/passenger.conf':
      ensure => absent
    }

    package {'git':
      ensure => installed
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_stg_app_shared/adops-shared",
    }

    common::nfsmount { "/app/ugc":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_stg_app_ugc/",
        options => "nfsvers=3,noatime,rw,rsize=32768,wsize=32768,hard,intr,tcp,noexec,nosuid",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_stg_app_log/app1v-adops.ap.stg.lax.gnmedia.net",
    }

    # Vhosts
    httpd::virtual_host {'stg.adops.gorillanation.com': uri => '/sessions/login', expect => 'forgot your password'}

    common::nfsromount { "/app/software":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_stg_app_shared/ap-software-stg",
    }

    # adopsv2
    ## database.yml creds
    ### rw creds
    $user_adplatform_rw_stg = 'adops_w'
    $pw_adplatform_rw_stg   = decrypt("/qvOZ9FdkiJB1xR9bz0T0w==")
    $host_adplatform_rw_stg = 'vip-sqlrw-adops.ap.stg.lax.gnmedia.net'

    ### rw migration creds, can run ddl
    $user_ap_migration_rw_stg = 'adops_migrate_w'
    $pw_ap_migration_rw_stg = decrypt('3bivMFz3yrsXgGhmlLKsPCqOA5ucYipTlP7vd1y2ITU=')

    ### ro creds
    $user_adplatform_ro_stg = 'adops_r'
    $pw_adplatform_ro_stg   = decrypt("+0JPZ0Fgz0Mxy0ALWL1VBA==")
    $host_adplatform_ro_stg = 'vip-sqlro-adops.ap.stg.lax.gnmedia.net'

    file {'/app/shared/docroots/adops.gorillanation.com/shared/config/database.yml':
        content => template('adops/database-stg.yml.erb'),
        owner   => 'adops-deploy',
        group   => 'adops-deploy',
    }

    ## phpmailer settings
    $env_adplatform_emailer = 'prod'
    $user_adplatform_emailer = 'emailer_r'
    $pw_adplatform_emailer = decrypt("2aPvOUty3kfkH5cqWSP6Ic0hL57JyDNT6/QmTK6gxuE=")
    $host_adplatform_emailer = 'VIP-SQLRO-adops.AP.STG.LAX.GNMEDIA.NET'

    file {'/app/shared/docroots/adops.gorillanation.com/shared/config/emailer_settings.ini':
        content => template('adops/emailer_settings.ini.erb'),
        owner   => 'adops-deploy',
        group   => 'adops-deploy',
    }
    ## end phpmailer settings


    # Define The adops environment in adops_env, for use with rake tasks.
    # Even though this is staging, it is set to production for now until it can be addressed in code.
    file {'/app/shared/docroots/adops.gorillanation.com/shared/config/adops_env':
      ensure  => file,
      owner   => 'adops-deploy',
      group   => 'adops-deploy',
      mode    => '0644',
      content => 'staging',
    }
}
