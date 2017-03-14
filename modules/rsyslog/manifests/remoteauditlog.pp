# class remoteauditlog

class rsyslog::remoteauditlog {
    file {'/etc/rsyslog.d/remoteauditlog.conf':
        source  => 'puppet:///modules/rsyslog/remoteauditlog.conf',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['/etc/rsyslog.d'],
        notify  => Service['rsyslog'],
    }
}
