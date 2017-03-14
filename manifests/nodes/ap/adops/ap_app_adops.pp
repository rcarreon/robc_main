# Common packages, files, and configs for adops app servers
class ap::app::adops {

    ### packages
    include common::app
    include httpd
    include adops::rbenv
    include adops::rubybase
    include logrotate::adops

    file { ['/app/local', '/app/ugc']:
        ensure  => directory,
        require => File['/app'],
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }

    # Docroot
    file { '/app/shared/docroots':
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        require => Class['httpd'],
    } ->
    file { '/app/shared/docroots/adops.gorillanation.com':
        ensure  => directory,
        owner   => 'deploy',
        group   => 'root',
        mode    => '0755',
    } ->
    file { '/app/shared/docroots/adops.gorillanation.com/config':
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    } ->
    file { '/app/shared/docroots/adops.gorillanation.com/releases':
        ensure  => directory,
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0755',
    }

    file { ['/app/ugc/uploads', '/app/ugc/uploads/csv', '/app/ugc/uploads/csv/historical_reports']:
        ensure  => directory,
        require => File['/app/ugc'],
        owner   => 'apache',
        group   => 'nobody',
        mode    => '0774',
    }

    # Apache VHosts logs, pubops and adops, need to be writeable by apache
    #
    file { '/app/local/logs/httpd':
        ensure  => directory,
        owner   => 'apache',
        group   => 'apache',
        mode    => '0755',
        require => File['/app/local/logs'],
    }

    file { '/app/log/adops':
        ensure  => directory,
        mode    => '0755',
        require => File['/app/log'],
        owner   => 'root',
        group   => 'root',
    }

    file { '/app/log/adops/adops-deploy':
        ensure  => directory,
        mode    => '0755',
        owner   => 'adops-deploy',
        group   => 'adops-deploy',
        require => File['/app/log/adops'],
    }

    file { '/app/log/adops/nobody':
        ensure  => directory,
        mode    => '0755',
        owner   => 'nobody',
        group   => 'nobody',
        require => File['/app/log/adops'],
    }

    file { '/app/log/adops/apache':
        ensure  => directory,
        mode    => '0755',
        owner   => 'apache',
        group   => 'apache',
        require => File['/app/log/adops'],
    }

    ### Packages
}


# DEV-specific configs
class ap::app::pubops::dev {

    include adops::devmail

    # app1v-only stuff -- CAREFUL, THIS IS APP2 FOR NOW
    if ($::fqdn_incr == '2' ) {
        # DB Credentials

    }

}

# STG-specific configs
class ap::app::pubops::stg {

    include adops::devmail

    # app1v-only stuff -- CAREFUL, THIS is APP3 FOR NOW
    if ($::fqdn_incr == '3' ) {

    }
}



# PRD-specific configs
class ap::app::pubops::prd {

    # app1v-only stuff -- CAREFUL, THIS is APP3 FOR NOW
    if ($::fqdn_incr == '3' ) {
        # DB Credentials
    }

}

