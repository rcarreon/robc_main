node 'app1v-adops.ap.dev.lax.gnmedia.net' {
    include base
    $project= 'adops'
    $prefix = 'ap'
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat

    include adops::packages
    include adops::packages::v3
    include adops::rbenv
    include adops::passenger4
    include adopsV3::appdirs
    include sendmail::tarpit
    include memcached

    include ap::app::workers

    package { 'tmux':
        ensure  => installed,
    }

    package { 'mysql':
        ensure  => installed,
    }

    class { "php::adops_memcache":
        memcache_servers => ["localhost"]
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/adops-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_log/app1v-adops.ap.dev.lax.gnmedia.net",
    }

    common::nfsmount { "/app/ugc":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_dev_app_ugc",
        options => "nfsvers=3,noatime,rw,rsize=32768,wsize=32768,hard,intr,tcp,noexec,nosuid",
    }

    common::nfsromount { "/app/software":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/ap-software-dev",
    }


    # vhosts
    httpd::virtual_host {"dev.adops.gorillanation.com": uri => '/sessions/login', expect => 'forgot your password'}
    httpd::virtual_host {"dev.pubops.gorillanation.com": uri => '/robots.txt', expect => 'User-agent' }
    #httpd::virtual_host {"dev.cta.pubops.gorillanation.com": uri => '/robots.txt', expect => 'norobots'}

    # adopsv2
    ## database.yml creds
    ### rw creds
    $user_adplatform_rw_dev = 'adops_w'
    $pw_adplatform_rw_dev = decrypt('17l3dAJ09V6BKagLdq6U1vpJBOf3rVKWHSuyt/4esIc=')
    $host_adplatform_rw_dev = 'sql1v-56-adops.ap.dev.lax.gnmedia.net'

    ### rw migration creds, can run ddl
    $user_ap_migration_rw_dev = 'adops_migrate_w'
    $pw_ap_migration_rw_dev = decrypt('JCqQ61Wa1Va2QSxmmE0nGQ==')

    ### ro creds
    $user_adplatform_ro_dev = 'adops_r'
    $pw_adplatform_ro_dev = decrypt('bAW0Wq76PbLAd7G+Uw2zqQ==')
    $host_adplatform_ro_dev = $host_adplatform_rw_dev

    ### salesforce creds (I don't believe these are used, but they were in the config)
    $user_adplatform_salesforce = 'admin@gorillanation.com'
    $pw_adplatform_salesforce = decrypt('Xx/IEq9KL83Y3MBmh2GCBA==')

    file { '/app/shared/docroots/adops.gorillanation.com/shared/config/database.yml':
      content => template('adops/database.yml.erb'),
    }

    ## phpmailer creds
    $env_adplatform_emailer = 'prod'
    $user_adplatform_emailer = 'emailer_r'
    $pw_adplatform_emailer = decrypt('BDGyfI4GxfctvtYN9KG9TA==')
    $host_adplatform_emailer = 'sql1v-56-adops.ap.dev.lax.gnmedia.net'

    file {'/app/shared/docroots/adops.gorillanation.com/shared/config/emailer_settings.ini':
        content => template('adops/emailer_settings.ini.erb')
    }

    ## end phpmailer creds

    # Define The adops environment in adops_env, for use with cron rake tasks
    file {"/app/shared/docroots/adops.gorillanation.com/shared/config/adops_env":
      ensure  => file,
      owner   => "adops-deploy",
      group   => "adops-deploy",
      mode    => "0644",
      content => 'development',
    }

    # Script to dump data for development
    file { '/usr/local/bin/mysqldump-adops':
        ensure  => 'present',
        owner   => 'nobody',
        group   => 'nobody',
        mode    => '0755',
        content => template('adops/mysqldump-adops'),
    }

    # adopsV3
    ## app_pubops database.php
    ### ro creds
    $host_adops_app_pubops_ro = "sql1v-56-pubops.ap.dev.lax.gnmedia.net"
    $user_adops_app_pubops_ro = "pubops_r"
    $pw_adops_app_pubops_ro = decrypt("Y6uMuc5+kX5vpnGyV+u/TQ==")

    ### rw creds
    $host_adops_app_pubops_rw = "sql1v-56-adops.ap.dev.lax.gnmedia.net"
    $user_adops_app_pubops_rw = "pubops_w"
    $pw_adops_app_pubops_rw = decrypt("Vhv2eldPSzDuhOY/iGcalzl2QR2B05v2c10CyMAOSvw=")

    ### pubops_reports
    $url_adops_app_pubops_pubops_reports = "http://dev.adops.gorillanation.com/pubops_reports_v3"
    $user_adops_app_pubops_pubops_reports = ""
    $pw_adops_app_pubops_pubops_reports = "" # this was in with a dev url and had blank login info, but I thought I should template it anyways

    file {"/app/shared/docroots/adopsV3/config/app_pubops.database.php":
        content => template("adops/app_pubops.database.php.erb")
    }
    ## end app_pubops database.php
}
