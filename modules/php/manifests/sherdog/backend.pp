# php serhdeog backend class
class php::sherdog::backend inherits php {

    file { '/etc/php.ini':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('php/php.ini-sdc-be.erb'),
        notify  => Service[httpd],
        require => Package['httpd'];
    }

    file { '/etc/php.d/memcache.ini':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('php/sherdog/sherdog_be_memcache.erb'),
        notify  => Service[httpd],
        require => Package['httpd'];
    }

}
