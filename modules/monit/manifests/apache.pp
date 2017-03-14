# monit apache alert/restart
class monit::apache inherits monit {
    file {'/etc/monit.d/apache.conf':
        ensure  => file,
        content => template('monit/apache.erb'),
        notify  => Service['monit'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    file {'/etc/monit.d/apache_restart':
        ensure => file,
        source => 'puppet:///modules/monit/apache_restart',
        owner  => 'root',
        group  => 'root',
        mode   => '0750',
    }
}
