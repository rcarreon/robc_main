# logrotate for adops3
class logrotate::adops3 {
    include logrotate
    file {'adops3':
        path    => '/etc/logrotate.d/adops3',
        content => template('logrotate/adops3.erb'),
        require => Class['logrotate'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
}

