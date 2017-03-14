# logrotate for remote audit log
class logrotate::remoteauditlog {

    include logrotate

    file {'/etc/logrotate.d/remoteauditlog':
        path    => '/etc/logrotate.d/remoteauditlog',
        content => template('logrotate/remoteauditlog.erb'),
        require => Class['logrotate'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
}
