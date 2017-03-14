# php stats
class php::stats inherits php {
    file { '/etc/php.ini':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('php/php.ini-stats.erb'),
        notify  => Service[httpd],
        require => Package['httpd'];
    }
}
