# used by the app-mta servers
class postfix::gateway inherits postfix {

    include postfix::dirs
    include logrotate::postfix_gateway

    service { 'mailgraph':
        ensure      => running,
        enable      => true,
        hasstatus   => true,
        require     => Package['mailgraph'],
    }

    service { 'httpd':
        ensure          => running,
        enable          => true,
        hasstatus       => true,
        require         => Package['mailgraph'],
    }

    service { 'postfix':
        ensure          => running,
        enable          => true,
        hasstatus       => true,
        require         => Package['postfix'],
    }

    service { 'amavisd':
        ensure          => running,
        enable          => true,
        hasstatus       => true,
        require         => Package['amavisd-new'],
    }

    service { 'clamd.amavisd':
        ensure          => running,
        enable          => true,
        hasstatus       => true,
        require         => [Package['clamd'],Package['amavisd-new']],
    }

    package { 'mailgraph':
        ensure      => present,
        require     => Class['postfix::dirs'],
    }

    package { 'postfix':
        ensure      => present,
        require     => Class['postfix::dirs'],
    }

    package { 'clamav':
        ensure      => present,
        require     => Class['postfix::dirs'],
    }

    package { 'clamd':
        ensure      => present,
        require     => Class['postfix::dirs'],
    }

    package { 'clamav-devel':
        ensure      => present,
        require     => Class['postfix::dirs'],
    }

    package { 'spamassassin':
        ensure      => present,
        require     => Class['postfix::dirs'],
    }

    package { 'amavisd-new':
        ensure      => present,
        require     => Class['postfix::dirs'],
    }

    file{'local.cf':
        ensure  => file,
        path    => '/etc/mail/spamassassin/local.cf',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['spamassassin'],
        notify  => Service['amavisd'],
        source  => 'puppet:///modules/postfix/spamassassin_local.cf',
    }

    file { '/etc/postfix/main.cf':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['postfix'],
        notify  => Service['postfix'],
        content => template('postfix/gateway-main.cf.erb'),
    }

    file { '/etc/postfix/master.cf':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['postfix'],
        notify  => Service['postfix'],
        source  => 'puppet:///modules/postfix/gateway-master.cf',
    }

    file { '/etc/amavisd/amavisd.conf':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['amavisd-new'],
        notify  => Service['amavisd'],
        content => template('postfix/amavisd.conf.erb'),
    }

    file { '/etc/postfix/header_checks':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['postfix'],
        notify  => Service['postfix'],
        source  => 'puppet:///modules/postfix/gateway-header_checks',
    }

}
