# php sbv cms ini class
class php::cms inherits php {
    file { '/etc/php.ini':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('php/php.ini-cms.erb'),
        notify  => Service[httpd],
        require => Package['httpd'];
    }
}
