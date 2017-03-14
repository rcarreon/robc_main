# class httpd::mod_security

    class httpd::mod_security inherits httpd {

    package { 'mod_security':
        ensure => installed,
    }

    file { '/etc/httpd/conf.d/mod_security.conf':
        ensure => present,
        group  => 'root',
        owner  => 'root',
        source => 'puppet:///modules/httpd/mod_security.conf',
        mode   => '0644',
    }

    file { '/etc/httpd/modsecurity.d':
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }

    file { '/app/shared/mod_security':
        ensure  => directory,
        mode    => '0770',
        owner   => 'apache',
        group   => 'root',
    }

    file { '/etc/httpd/modsecurity.d/switched_rules':
        ensure  => directory,
        mode    => '0644',
        require => File['/etc/httpd/modsecurity.d'],
    }
}
