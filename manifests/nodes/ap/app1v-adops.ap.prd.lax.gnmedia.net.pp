node 'app1v-adops.ap.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="adops"
    include adops::common
    include adops::packages
    include adops::packages::v3
    include adops::rbenv
    include adops::passenger4
    include adopsV3::appdirs
    include adops::newrelic::apm
    include adops::newrelic::sysmond
    include pipestash

    file {'/etc/httpd/conf.d/passenger-adops.conf':
      ensure => absent
    }

    file {'/etc/httpd/conf.d/passenger.conf':
      ensure => absent
    }

    package {'git':
      ensure => installed
    }

    # mounts
    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_shared/adops-shared",
    }

    common::nfsmount { "/app/ugc":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_prd_app_ugc/",
        options => "nfsvers=3,noatime,rw,rsize=32768,wsize=32768,hard,intr,tcp,noexec,nosuid",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_log/app1v-adops.ap.prd.lax.gnmedia.net",
    }

    common::nfsromount { "/app/software":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_shared/ap-software-prd",
    }

    class { "php::adops_memcache":
        memcache_servers => ["mem1v-adops.ap.prd.lax.gnmedia.net","mem2v-adops.ap.prd.lax.gnmedia.net"]
    }

    # Vhosts
    httpd::virtual_host {"adops.gorillanation.com": uri => '/sessions/login', expect => 'forgot your password'}

    # newprod and cta pubops disabled on 5/13/2014
    #   httpd::virtual_host {"newprod.pubops.evolvemediacorp.com": uri => '/robots.txt', expect => 'User-agent'}
    #   httpd::virtual_host {"cta.pubops.evolvemediacorp.com": uri => '/robots.txt', expect => 'norobots'}
    # disabled around 2/2014
    #   httpd::virtual_host {"pubops-legacy.gorillanation.com": uri => '/sessions/login', expect => 'forgot your password'}
    # redirect vhost
    # httpd::virtual_host {"pubops.gorillanation.com": monitor => false}

    # adopsv2
    ## database.yml creds
    ### rw creds
    $user_adplatform_rw_prd = "adops_w"
    $pw_adplatform_rw_prd = decrypt("wlXLHuKnGkYv2Hf/IUtzRw==")
    $host_adplatform_rw_prd = "vip-sqlrw-adops.ap.prd.lax.gnmedia.net"

    ### rw migration creds, can run ddl
    $user_ap_migration_rw_prd = 'adops_migrate_w'
    $pw_ap_migration_rw_prd = decrypt('tXzhao5YJJPeYvwcqDHhhndf0mXdSoabZyYJHLngteo=')

    ### ro creds
    $user_adplatform_ro_prd = "adops_r"
    $pw_adplatform_ro_prd = decrypt("KpEUz0c8QdVuxgBzIoTnTg==")
    $host_adplatform_ro_prd = "vip-sqlro-adops.ap.prd.lax.gnmedia.net"

    ### salesforce creds
    $user_adplatform_salesforce = "admin@gorillanation.com"
    $pw_adplatform_salesforce = decrypt("Xx/IEq9KL83Y3MBmh2GCBA==")

    file {"/app/shared/docroots/adops.gorillanation.com/shared/config/database.yml":
        content => template("adops/database-prod.yml.erb"),
        owner   => 'adops-deploy',
        group   => 'adops-deploy',
    }

    ## phpmailer settings
    $env_adplatform_emailer = "prod"
    $user_adplatform_emailer = "emailer_r"
    $pw_adplatform_emailer = decrypt("ftulqt3lX1t7HjQeFejMqQ==")
    $host_adplatform_emailer = "vip-sqlro-adops.ap.prd.lax.gnmedia.net"

    file {"/app/shared/docroots/adops.gorillanation.com/shared/config/emailer_settings.ini":
        content => template("adops/emailer_settings.ini.erb"),
        owner   => 'adops-deploy',
        group   => 'adops-deploy',
    }
    ## end phpmailer settings


    # Define The adops environment in adops_env, for use with cron rake tasks
    file {'/app/shared/docroots/adops.gorillanation.com/shared/config/adops_env':
      ensure  => file,
      owner   => 'adops-deploy',
      group   => 'adops-deploy',
      mode    => '0644',
      content => 'production',
    }

}
