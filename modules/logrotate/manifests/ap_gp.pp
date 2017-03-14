# logrotate for ap dfp_coordinator
class logrotate::ap_gp {
    include logrotate
    file {'ap_gp':
        path    => '/etc/logrotate.d/ap_gp',
        content => template('logrotate/ap_gp.erb'),
        require => Class['logrotate'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
}

