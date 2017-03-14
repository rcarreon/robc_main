# logrotate for pubops
class logrotate::pubops {
    include logrotate
    file {'pubops':
        path    => '/etc/logrotate.d/pubops',
        content => template('logrotate/pubops.erb'),
        require => Class['logrotate'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
}

