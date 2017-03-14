# php shh class
class php::shh inherits php {
    file { '/etc/php.ini':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('php/php.ini-shh.erb'),
        notify  => Service[httpd],
        require => Package['httpd'];
    }

}
