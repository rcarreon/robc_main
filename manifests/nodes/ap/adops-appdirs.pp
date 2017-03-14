# directories needed for adops
class adops::appdirs {
    include common::app
    include httpd
    include logrotate::adops

    # Logs
# /app/local and /app/ugc may only be needed on adops
    file { ['/app/local', '/app/ugc']:
        ensure  => directory,
        require => File['/app'],
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }

    # Capistrano will deploy to these systems
    if ($::fqdn_role != 'uid' and $::fqdn_type != 'build') {
    #    notify{"again, not uid and not build":}

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
            owner   => 'adops-deploy',
            group   => 'root',
            mode    => '0755',
        } ->
        file { '/app/shared/docroots/adops.gorillanation.com/shared':
            ensure  => directory,
            owner   => 'adops-deploy',
            group   => 'adops-deploy',
            mode    => '0755',
        } ->
        file { '/app/shared/docroots/adops.gorillanation.com/shared/config':
            ensure  => directory,
            owner   => 'adops-deploy',
            group   => 'adops-deploy',
            mode    => '0755',
        } ->
        file { '/app/shared/docroots/adops.gorillanation.com/releases':
            ensure  => directory,
            owner   => 'adops-deploy',
            group   => 'adops-deploy',
            mode    => '0755',
        }
    }

    file { [
            '/app/ugc/uploads',
            '/app/ugc/uploads/csv',
            '/app/ugc/uploads/csv/historical_reports',
            '/app/ugc/uploads/csv/payout_reports',
        ]:
        ensure  => directory,
        require => File['/app/ugc'],
        owner   => 'apache',
        group   => 'nobody',
        mode    => '0774',
    }

    # Mail logs
    ## Mail tarpit, stg/dev send all email to a log file
    ## Production has root mail to here
    file {'/app/local/logs':
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        require => File['/app/local'],
    }
    file { '/app/local/logs/maillogs':
        ensure  => directory,
        owner   => 'mailnull',
        group   => 'mailnull',
        mode    => '0755',
        require => File['/app/local/logs'],
    } ->
    file { '/app/local/logs/maillogs/mail-tarpit.log':
        ensure  => file,
        owner   => 'mailnull',
        group   => 'mailnull',
        mode    => '0666',
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

    file { [
            '/app/shared/tmp/sk_subnet_reports',
            '/app/shared/tmp/sk_subnet_reports/csv'
        ]:
        ensure => directory,
        owner  => 'nobody',
        group  => 'nobody',
        mode   => '0755',
    }


}

# directories needed by adopsV3
class adopsV3::appdirs {
    include adops::appdirs
    include logrotate::adops3

    # Capistrano will deploy to these systems
    if ($::fqdn_role != 'uid' and $::fqdn_type != 'build') {
    #    notify{"not uid and not build":}

        file { '/app/shared/docroots/adopsV3':
            ensure  => directory,
            owner   => 'deploy',
            group   => 'root',
            mode    => '0755',
            require => File['/app/shared/docroots'],
        } ->
        file { '/app/shared/docroots/adopsV3/config':
            ensure  => directory,
            owner   => 'root',
            group   => 'root',
            mode    => '0755',
        } ->
        file { '/app/shared/docroots/adopsV3/releases':
            ensure  => directory,
            owner   => 'deploy',
            group   => 'deploy',
            mode    => '0755',
        }
    }

# This should move to dfp::appdirs when adops3 is retired
#    file { ['/app/shared/tmp','/app/shared/tmp/dfp_performance','/app/shared/tmp/dfp_report_scheduler','/app/shared/tmp/rtb_performance']:
    file { ['/app/shared/tmp']:
            ensure => directory,
            owner  => 'apache',
            group  => 'apache',
            mode   => '0775',
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

    file { '/app/log/adops3/nobody':
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

}
