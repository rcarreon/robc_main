# logrotate for adops
class logrotate::adops {
    include logrotate
    file {'adops':
        path    => '/etc/logrotate.d/adops',
        content => template('logrotate/adops.erb'),
        require => Class['logrotate'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
}
