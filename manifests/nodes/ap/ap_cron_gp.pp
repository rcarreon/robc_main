# Requirements for running ap_gp_coordinator on a cron server
class ap::cron::gp {

    # PACKAGES

    # freetds is a set of libraries that allow your programs to natively talk to Microsoft SQL Server
    package {'freetds':
            ensure => present,
    }

    file {'/etc/freetds.conf':
        ensure  => file,
        content => template('adops/freetds.conf.erb'),
        owner   => 'root',
        group   => 'root',
        require => Package['freetds'],
    }

    # DIRECTORIES

    # Docroot
    # Capistrano will deploy to these systems
    if ($::fqdn_role != 'uid' and $::fqdn_type != 'build') {
        file { '/app/shared/docroots/gp_coordinator':
            ensure  => directory,
            owner   => 'deploy',
            group   => 'root',
            mode    => '0755',
        } ->
        file { '/app/shared/docroots/gp_coordinator/config':
            ensure  => directory,
            owner   => 'root',
            group   => 'root',
            mode    => '0755',
        } ->
        file { '/app/shared/docroots/gp_coordinator/releases':
            ensure  => directory,
            owner   => 'deploy',
            group   => 'deploy',
            mode    => '0755',
        }
    }

    # tmp and log directories
    file { ['/tmp/gp','/app/log/gp','/app/log/gp/apache']:
        ensure => directory,
        owner  => 'apache',
        group  => 'apache',
        mode   => '0775',
    }

    include logrotate::ap_gp

}

# DEV-specific configs
class ap::cron::gp::dev {

    # app1v-only
    if ($::fqdn_incr == '1' ) {
        # DB Credentials

        ## app_gp_scheduler database.php
        ### ro creds
        $host_adops_app_gp_scheduler_ro = 'sql1v-56-adops.ap.dev.lax.gnmedia.net'
        $user_adops_app_gp_scheduler_ro = 'adops_r'
        $pw_adops_app_gp_scheduler_ro = decrypt('bAW0Wq76PbLAd7G+Uw2zqQ==')

        ### rw creds
        $host_adops_app_gp_scheduler_rw = 'sql1v-56-adops.ap.dev.lax.gnmedia.net'
        $user_adops_app_gp_scheduler_rw = 'adops_w'
        $pw_adops_app_gp_scheduler_rw = decrypt('17l3dAJ09V6BKagLdq6U1vpJBOf3rVKWHSuyt/4esIc=')

        ### great_plains creds
        $host_adops_app_gp_scheduler_great_plains = 'evlaadops03.gorillanation.local:1433'
        $user_adops_app_gp_scheduler_great_plains = 'sa'
        $pw_adops_app_gp_scheduler_great_plains = decrypt('Gvq+8DBtfe8SptLGPoNFAg==')

        file {'/app/shared/docroots/gp_coordinator/config/app_gp_scheduler.database.php':
            ensure  => present,
            content => template('adops/app_gp_scheduler.database.php.erb'),
            owner   => 'root',
            group   => 'root',
        }
    }
}

# STG-specific configs
class ap::cron::gp::stg {

    # app1v-only
    if ($::fqdn_incr == '1' ) {
        # DB Credentials

        ## app_gp_scheduler database.php
        ### ro creds
        $host_adops_app_gp_scheduler_ro = 'vip-sqlro-adops.ap.stg.lax.gnmedia.net'
        $user_adops_app_gp_scheduler_ro = 'adops_r'
        $pw_adops_app_gp_scheduler_ro = decrypt('+0JPZ0Fgz0Mxy0ALWL1VBA==')

        ### rw creds
        $host_adops_app_gp_scheduler_rw = 'vip-sqlrw-adops.ap.stg.lax.gnmedia.net'
        $user_adops_app_gp_scheduler_rw = 'adops_w'
        $pw_adops_app_gp_scheduler_rw = decrypt('/qvOZ9FdkiJB1xR9bz0T0w==')

        ### great_plains creds
        $host_adops_app_gp_scheduler_great_plains = 'evlaadops03.gorillanation.local:1433'
        $user_adops_app_gp_scheduler_great_plains = 'sa'
        $pw_adops_app_gp_scheduler_great_plains = decrypt('Gvq+8DBtfe8SptLGPoNFAg==')

        file {'/app/shared/docroots/gp_coordinator/config/app_gp_scheduler.database.php':
            content => template('adops/app_gp_scheduler.database.php.erb'),
            owner   => 'root',
            group   => 'root',
        }
    }
}

# PRD-specific configs
class ap::cron::gp::prd {

    # app1v-only
    if ($::fqdn_incr == '1' ) {
        # DB Credentials

        ## app_gp_scheduler database.php
        ### ro creds
        $host_adops_app_gp_scheduler_ro = 'vip-sqlro-adops.ap.prd.lax.gnmedia.net'
        $user_adops_app_gp_scheduler_ro = 'adops_r'
        $pw_adops_app_gp_scheduler_ro = decrypt('KpEUz0c8QdVuxgBzIoTnTg==')

        ### rw creds
        $host_adops_app_gp_scheduler_rw = 'vip-sqlrw-adops.ap.prd.lax.gnmedia.net'
        $user_adops_app_gp_scheduler_rw = 'adops_w'
        $pw_adops_app_gp_scheduler_rw = decrypt('wlXLHuKnGkYv2Hf/IUtzRw==')

        ### great plains creds
        $host_adops_app_gp_scheduler_great_plains = 'evlasqlcl01.gorillanation.local:55275'
        $user_adops_app_gp_scheduler_great_plains = 'Gorillanation\Svc_ADWEB'
        $pw_adops_app_gp_scheduler_great_plains = decrypt('ygx2Tp6Vge0CywsxSKdhFQ==')

        file {'/app/shared/docroots/gp_coordinator/config/app_gp_scheduler.database.php':
            content => template('adops/app_gp_scheduler.database.php.erb'),
            owner   => 'root',
            group   => 'root',
        }
    }
}
