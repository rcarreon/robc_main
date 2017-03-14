# atp php ini class
class php::atp inherits php {
    file { '/etc/php.ini':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('php/php.ini-atp.erb'),
        notify  => Service[httpd],
        require => Package['httpd'];
    }
}
