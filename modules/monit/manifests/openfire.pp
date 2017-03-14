# monit for openfire
class monit::openfire inherits monit {
    file {'/etc/monit.d/openfire.conf':
        ensure  => file,
        content => template('monit/openfire.erb'),
        notify  => Service['monit'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    file {'/etc/monit.d/openfire_restart':
        ensure => file,
        source => 'puppet:///modules/monit/openfire_restart',
        owner  => root,
        group  => root,
        mode   => '0750',
    }
}
