# class postfix_gateway

class rsyslog::postfix_gateway {
    file {'/etc/rsyslog.d/postfix_gateway.conf':
        source  => 'puppet:///modules/rsyslog/postfix_gateway.conf',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['/etc/rsyslog.d'],
        notify  => Service['rsyslog'],
    }
}
