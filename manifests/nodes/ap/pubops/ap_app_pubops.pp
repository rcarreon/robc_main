# Common packages, files, and configs for pubops (on rails) app servers
class ap::app::pubops {

    ### packages
    include common::app
    include httpd
    include adops::rbenv
    include adops::rubybase
    include adops::passenger4
    include logrotate::pubops

    ### appdirs
    # docroot
    file { '/app/shared/docroots':
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        require => Class['httpd'],
    } ->
    file { '/app/shared/docroots/pubops.evolvemediacorp.com':
        ensure  => directory,
        owner   => 'adops-deploy',
        group   => 'adops-deploy',
        mode    => '0755',
    } ->
    file { '/app/shared/docroots/pubops.evolvemediacorp.com/shared':
        ensure  => directory,
        owner   => 'adops-deploy',
        group   => 'adops-deploy',
        mode    => '0755',
    }->
    file { '/app/shared/docroots/pubops.evolvemediacorp.com/shared/config':
        ensure  => directory,
        owner   => 'adops-deploy',
        group   => 'adops-deploy',
        mode    => '0755',
    } ->
    file { '/app/shared/docroots/pubops.evolvemediacorp.com/releases':
        ensure  => directory,
        owner   => 'adops-deploy',
        group   => 'adops-deploy',
        mode    => '0755',
    }

    file { '/app/log/pubops':
        ensure  => directory,
        mode    => '0755',
        require => File['/app/log'],
        owner   => 'root',
        group   => 'root',
    }

    file { '/app/log/pubops/nobody':
        ensure  => directory,
        mode    => '0755',
        owner   => 'nobody',
        group   => 'nobody',
        require => File['/app/log/pubops'],
    }

    file { '/app/log/pubops/apache':
        ensure  => directory,
        mode    => '0755',
        owner   => 'apache',
        group   => 'apache',
        require => File['/app/log/pubops'],
    }

    file { '/app/log/pubops/adops-deploy':
        ensure  => directory,
        mode    => '0755',
        owner   => 'adops-deploy',
        group   => 'adops-deploy',
        require => File['/app/log/pubops'],
    }

    $app_name = 'pubops'
    class {'adops::newrelic::sysmond':
      app_name => $app_name
    }
    class {'adops::newrelic::apm':
      app_name => $app_name
    }
}

# DEV-specific configs
class ap::app::pubops::dev {

    include adops::devmail

#    # app1v-only stuff
    if ($::fqdn_incr == '1' ) {
        # DB Credentials
        $env_app_pubops_webui_ro = 'development'
        $host_app_pubops_webui_ro = 'sql1v-56-adops.ap.dev.lax.gnmedia.net'
        $user_app_pubops_webui_ro = 'pubops_webui_r'
        $pw_app_pubops_webui_ro = decrypt('+aAYxbZykJ7Y/bl4lb5z5A==')

        # Secret Key Base
        $secret_key_env_pubops_webui = 'development'
        $secret_key_base_pubops_webui = decrypt('q+QIvt8ImWaXgORzGhVq9821YprUbyvyUQ5eTPRGh60qAZd59n6fMLU7o+M60yLhVMQroaID/vCW3CWkPRssA0hD68nbGOSvZOTE03U/8GnRTvrWgBhpi2QcDoMx70EEMjbYk6rE4xvVYYiuKPQNuzdr4H+bbWoUM+oVitBWfft8GXTH8H7HI8wY6l8mLW7n')

        file {'/app/shared/docroots/pubops.evolvemediacorp.com/shared/config/database.yml':
            content => template('adops/app_pubops_webui_database.yml.erb'),
            owner   => 'adops-deploy',
            group   => 'adops-deploy',
        }

        # Define The adops environment in adops_env, for use with cron rake tasks
        file {'/app/shared/docroots/pubops.evolvemediacorp.com/shared/config/pubops_webui_env':
            ensure  => file,
            owner   => 'adops-deploy',
            group   => 'adops-deploy',
            mode    => '0644',
            content => 'development',
        }

        $jira_user_pubops_webui = 'pubopsapi'
        $jira_pass_pubops_webui = decrypt('4/Q1VJ6NwBgl8wz64Pixfg==')
        file { '/app/shared/docroots/pubops.evolvemediacorp.com/shared/config/secrets.yml':
            ensure  => file,
            content => template('adops/app_pubops_webui.secrets.yml.erb'),
            owner   => 'root',
            group   => 'root',
            mode    => '0755',
            require => File['/app/shared/docroots/pubops.evolvemediacorp.com/shared/config'],
        }
    }
}

# STG-specific configs
class ap::app::pubops::stg {

    include adops::devmail

    # app1v-only stuff -- CAREFUL, THIS is APP3 FOR NOW
    if ($::fqdn_incr == '3' ) {
        package { 'git': ensure => installed, }

        # DB Credentials
        $env_app_pubops_webui_ro = 'staging'
        $host_app_pubops_webui_ro = 'vip-sqlro-adops.ap.stg.lax.gnmedia.net'
        $user_app_pubops_webui_ro = 'pubops_webui_r'
        $pw_app_pubops_webui_ro = decrypt('213+HqpBQzZ3USZttBQOdw==')

        # Secret Key Base
        $secret_key_env_pubops_webui = 'staging'
        $secret_key_base_pubops_webui = decrypt('E+LYmkcvfM+KZhe5CyuPaCBCjgQICaCMqgmPuHHEF1Q6Or6ZFDzgnPGP0Z0TREzRWQmeRvu2Zs04z7N0GSLIisN80U7+kTfkMNOlXlERlHdVFH0Q6ltRK8DCHlKd+alNCssTKjxjfkMVleXETtBmj242FgPb53C/LRR8t6NS3BAvTppGFBQ7pS4VFUbzrc4x')

        file {'/app/shared/docroots/pubops.evolvemediacorp.com/shared/config/database.yml':
            content => template('adops/app_pubops_webui_database.yml.erb'),
            owner   => 'adops-deploy',
            group   => 'adops-deploy',
        }

        # Define The adops environment in adops_env, for use with cron rake tasks
        file {'/app/shared/docroots/pubops.evolvemediacorp.com/shared/config/pubops_webui_env':
            ensure  => file,
            owner   => 'adops-deploy',
            group   => 'adops-deploy',
            mode    => '0644',
            content => 'staging',
        }

        $jira_user_pubops_webui = 'pubopsapi'
        $jira_pass_pubops_webui = decrypt('4/Q1VJ6NwBgl8wz64Pixfg==')
        file { '/app/shared/docroots/pubops.evolvemediacorp.com/shared/config/secrets.yml':
            ensure  => file,
            content => template('adops/app_pubops_webui.secrets.yml.erb'),
            owner   => 'adops-deploy',
            group   => 'adops-deploy',
            mode    => '0755',
            require => File['/app/shared/docroots/pubops.evolvemediacorp.com/shared/config'],
        }
    }
}

# PRD-specific configs
class ap::app::pubops::prd {

    # app1v-only stuff -- CAREFUL, THIS is APP3 FOR NOW
    if ($::fqdn_incr == '3' ) {
        package { 'git': ensure => installed, }

        # DB Credentials
        $env_app_pubops_webui_ro = 'production'
        $host_app_pubops_webui_ro = 'vip-sqlro-pubops.ap.prd.lax.gnmedia.net'
        $user_app_pubops_webui_ro = 'pubops_webui_r'
        $pw_app_pubops_webui_ro = decrypt('Kdg2UowqH546tRrnrCBqUA==')

        # Secret Key Base
        $secret_key_env_pubops_webui = 'production'
        $secret_key_base_pubops_webui = decrypt('Cb4srBVW68UYh6dgPQhAADECuhk2JVPM8dqoJpVYIq2khotMAdJ96kRAAsAQj0VyKMGgAuHw5e80TSKJyvyzGJfr3af3zzAVDe2HocG/p0mhD6HpEmtZzi5TrF8qIqzeC0aKK9aNi2jPTaTU4MmUcWjnFVMK8sVXhODObjlduCWQJiZZ9lkuVf2rEhZbusRC')

        file {'/app/shared/docroots/pubops.evolvemediacorp.com/shared/config/database.yml':
            content => template('adops/app_pubops_webui_database.yml.erb'),
            owner   => 'adops-deploy',
            group   => 'adops-deploy',
        }

        # Define The adops environment in adops_env, for use with cron rake tasks
        file {'/app/shared/docroots/pubops.evolvemediacorp.com/shared/config/pubops_webui_env':
            ensure  => file,
            owner   => 'adops-deploy',
            group   => 'adops-deploy',
            mode    => '0644',
            content => 'production',
        }

        $jira_user_pubops_webui = 'pubopsapi'
        $jira_pass_pubops_webui = 'not-availble-yet'
        file { '/app/shared/docroots/pubops.evolvemediacorp.com/shared/config/secrets.yml':
            ensure  => file,
            content => template('adops/app_pubops_webui.secrets.yml.erb'),
            owner   => 'adops-deploy',
            group   => 'adops-deploy',
            mode    => '0755',
            require => File['/app/shared/docroots/pubops.evolvemediacorp.com/shared/config'],
        }
    }
}
