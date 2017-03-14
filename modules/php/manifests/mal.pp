# php mal class
class php::mal inherits php {

    file { '/etc/php.ini':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('php/php.ini-mal.erb'),
        notify  => Service[httpd],
        require => Package['httpd'];
    }

    package { 'php-mbstring':
        ensure => present,
    }
}
