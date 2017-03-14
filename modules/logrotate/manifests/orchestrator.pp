# logrotate for orchestrator
class logrotate::orchestrator {
    include logrotate
    file {'orchestrator':
        path    => '/etc/logrotate.d/orchestrator',
        content => template('logrotate/orchestrator.erb'),
        require => Class['logrotate'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
}

