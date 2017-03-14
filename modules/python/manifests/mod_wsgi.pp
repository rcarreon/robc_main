# python mod_wsgi class
class python::mod_wsgi inherits python {
    package { 'mod_python':
        ensure => absent,
    }
    package { 'mod_wsgi':
        ensure => installed,
    }
        file { '/etc/httpd/wsgi':
            ensure  => directory,
            owner   => 'root',
            group   => 'root',
            mode    => '0755',
            source  => 'puppet:///modules/common/empty-directory',
    }

    file {'/etc/httpd/conf.d/wsgi.conf':
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
                source  => 'puppet:///modules/python/wsgi.conf',
                notify  => Class['httpd::base']
    }
}
