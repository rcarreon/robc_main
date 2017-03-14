# Common packages, files, and configs for tags app servers
class ap::app::tags {
    #$project='adops'

    ### packages
    include common::app
    include httpd
    include php::adops
    include logrotate::adops3

    ### appdirs
    # docroot
    file { '/app/shared/docroots':
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        require => Class['httpd'],
    } ->
    file { '/app/shared/docroots/tags.evolvemediallc.com':
        ensure  => directory,
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0755',
    } ->
    file { '/app/shared/docroots/tags.evolvemediallc.com/config':
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }

    # this may not be needed
    file { ['/app/shared/tmp']:
        ensure => directory,
        owner  => 'apache',
        group  => 'apache',
        mode   => '0755',
    }

    file { '/app/log/adops3':
        ensure  => directory,
        mode    => '0755',
        require => File['/app/log'],
        owner   => 'root',
        group   => 'root',
    }

    file { '/app/log/adops3/apache':
        ensure  => directory,
        owner   => 'apache',
        group   => 'apache',
        mode    => '0755',
        require => File['/app/log/adops3'],
    }

    file{'/tmp/cache':
        ensure  => directory,
        owner   => 'apache',
        group   => 'apache',
        mode    => '0755',
    }

    file{'/tmp/cache/models':
        ensure  => directory,
        owner   => 'apache',
        group   => 'apache',
        mode    => '0755',
    }

    file{'/tmp/cache/persistent':
        ensure  => directory,
        owner   => 'apache',
        group   => 'apache',
        mode    => '0755',
    }

    file {'/etc/cron.daily/tmpwatch':
        ensure => absent,
    }

    # Auth credentials for Akamai cache clearing
    $akamai_host      = 'https://api.ccu.akamai.com'
    $akamai_url_purge = '/ccu/v2/queues/default'
    $akamai_user      = 'sysadmins@gorillanation.com'
    $akamai_password  = decrypt('en8ppWT0HQUyU4yBH/cCGkSx6E/K1HLKrmV6CetM7qg=')

    file { '/app/shared/docroots/tags.evolvemediallc.com/config/akamai_auth.ini':
        ensure  => file,
        content => template('adops/akamai_auth.ini.erb'),
        owner   => 'root',
        group   => 'root',
    }

}


# DEV-specific configs
class ap::app::tags::dev {

    # app1v-only stuff
    if ($::fqdn_incr == '1' ) {
        # DB Credentials
        $host_ap_app_tags_ro = 'sql1v-56-tags.ap.dev.lax.gnmedia.net'
        $user_ap_app_tags_ro = 'tags_r'
        $pw_ap_app_tags_ro = decrypt('k5nmawDm43CKyi5CQNMSsg==')
        $db_ap_app_tags_ro = 'adops2_0_production'

        file {'/app/shared/docroots/tags.evolvemediallc.com/config/app_tags.database.php':
            content => template('adops/app_tags.database.php.erb'),
            owner   => 'root',
            group   => 'root',
        }
    }

}

# STG-specific configs
class ap::app::tags::stg {

    # app1v-only stuff
    if ($::fqdn_incr == '1' ) {
        # DB Credentials
        $host_ap_app_tags_ro = 'vip-sqlro-tags.ap.stg.lax.gnmedia.net'
        $user_ap_app_tags_ro = 'tags_r'
        $pw_ap_app_tags_ro = decrypt('5Z4Pe1YbxD+U5XfYqQYeMQ==')
        $db_ap_app_tags_ro = 'adops2_0_production'

        file {'/app/shared/docroots/tags.evolvemediallc.com/config/app_tags.database.php':
            content => template('adops/app_tags.database.php.erb'),
            owner   => 'root',
            group   => 'root',
        }
    }
}

# PRD-specific configs
class ap::app::tags::prd {

    # app1v-only stuff
    if ($::fqdn_incr == '1' ) {
        # DB Credentials
        $host_ap_app_tags_ro = 'vip-sqlro-tags.ap.prd.lax.gnmedia.net'
        $user_ap_app_tags_ro = 'tags_r'
        $pw_ap_app_tags_ro = decrypt('YHtw3q+QyYiMIjivmxuEDQ==')
        $db_ap_app_tags_ro = 'adops2_0_production'

        file {'/app/shared/docroots/tags.evolvemediallc.com/config/app_tags.database.php':
            content => template('adops/app_tags.database.php.erb'),
            owner   => 'root',
            group   => 'root',
        }
    }

}
