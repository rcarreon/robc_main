# logrotate for ap dfp_coordinator
class logrotate::ap_dfp {
    include logrotate
    file {'ap_dfp':
        path    => '/etc/logrotate.d/ap_dfp',
        content => template('logrotate/ap_dfp.erb'),
        require => Class['logrotate'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
}

