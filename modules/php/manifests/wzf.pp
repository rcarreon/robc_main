# php wzf
class php::wzf inherits php {
    file { '/etc/php.ini':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('php/php.ini-wzf.erb'),
        notify  => Service[httpd],
        require => Package['httpd'];
    }
}
