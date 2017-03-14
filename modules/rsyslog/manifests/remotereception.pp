# class remotereception

class rsyslog::remotereception {
    file {'/etc/rsyslog.d/remotereception.conf':
        source  => 'puppet:///modules/rsyslog/remotereception.conf',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['/etc/rsyslog.d'],
        notify  => Service['rsyslog'],
    }
}
