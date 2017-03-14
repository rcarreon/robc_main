# php media cloass
class php::media inherits php {
    file { '/etc/php.ini':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('php/php.ini-media.erb'),
        notify  => Service[httpd],
        require => Package['httpd'];
    }
}
