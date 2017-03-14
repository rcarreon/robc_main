# class logstash

class rsyslog::logstash {
    file {'/etc/rsyslog.d/logstash.conf':
        source  => 'puppet:///modules/rsyslog/logstash.conf',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['/etc/rsyslog.d'],
        notify  => Service['rsyslog'],
    }
}
