# class xcatremote

class rsyslog::xcatremote {
    file {'/etc/rsyslog.d/xcat-remote.conf':
        source  => 'puppet:///modules/rsyslog/xcat-remote.conf',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['/etc/rsyslog.d'],
        notify  => Service['rsyslog'],
    }
}
