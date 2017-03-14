# common configs for app-origin.og.prd servers
class origin::app_origin_prd {

    include common::app
    include httpd

    # PHP stuff
    include yum::ius
    package { ['php54', 'php54-cli', 'php54-common', 'php54-mcrypt', 'php54-mysql', 'php54-mbstring.x86_64']: ensure => installed, }

    httpd::virtual_host {'originplatform.com': monitor => false }

    file { '/app/log/laravel':
        ensure => directory,
        owner  => 'apache',
        group  => 'apache',
        mode   => '0755',
    }

    logrotate::rotate_logs_in_dir { 'laravel':
        directory => '/app/log/laravel',
    }

    # app1v-only stuff
    if ($::fqdn_incr == '1' ) {

        include subversion::client
        include git::client

        ###### DB Credentials
        ## RO to origin database
        $origin_ro_user = 'origin_r'
        $origin_ro_pw   = decrypt('7SwoZKwrr2wJiEGaUznWEw==')
        $origin_ro_host = 'VIP-SQLRO-ORIGIN.OG.PRD.LAX'
        $origin_ro_db   = 'origin'

        ## RW to origin database
        $origin_rw_user = 'origin_w'
        $origin_rw_pw   = decrypt('dJExtSqGiOGis75004NvlQ==')
        $origin_rw_host = 'VIP-SQLRW-ORIGIN.OG.PRD.LAX'
        $origin_rw_db   = 'origin'

        ## RO to analytics database
        $analytics_ro_host = 'vip-sqlro-bd.og.prd.lax.gnmedia.net'
        $analytics_ro_db = 'analytics'
        $analytics_ro_user = 'analytics_r'
        $analytics_ro_pw = decrypt('U76YE+wBrvOrEXcx+RpBCg==')

        ## RO to audit database
        $audit_ro_user  = 'audit_r'
        $audit_ro_pw    = decrypt('jSris0VHMjK9UFngcqTTsw==')
        $audit_ro_host  = 'VIP-SQLRO-ORIGIN.OG.PRD.LAX'
        $audit_ro_db    = 'audit'

        ## RW to audit database
        $audit_rw_user  = 'audit_w'
        $audit_rw_pw    = decrypt('6zDYErj1rnxsTftxox6z3A==')
        $audit_rw_host  = 'VIP-SQLRW-ORIGIN.OG.PRD.LAX'
        $audit_rw_db    = 'audit'
        ###### End of DB Credentials

        file { '/app/shared/docroots/originplatform.com/config/app_originplatform_database.php':
            ensure  => present,
            content => template('origin/app_originplatform_database.php.erb'),
            require => File['/app/shared/docroots/originplatform.com/config'],
        }

        # Docroot directories
        file { '/app/shared/docroots':
            ensure  => directory,
            owner   => 'root',
            group   => 'root',
            mode    => '0755',
            require => Class['httpd'],
        } ->
        file { '/app/shared/docroots/originplatform.com':
            ensure  => directory,
            owner   => 'em-deploy',
            group   => 'root',
            mode    => '0755',
        } ->
        file { '/app/shared/docroots/originplatform.com/config':
            ensure  => directory,
            owner   => 'root',
            group   => 'root',
            mode    => '0755',
        }

    }

}
