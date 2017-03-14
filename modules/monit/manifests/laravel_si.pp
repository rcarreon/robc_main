# monit for laravel si queue listener 
class monit::laravel_si inherits monit {
    file {'/etc/monit.d/queue_listen_laravel.conf':
        ensure  => file,
        content => template('monit/queue_listen_laravel.erb'),
        notify  => Service['monit'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    file {'/etc/monit.d/listen_laravel_restart':
        ensure => file,
        source => 'puppet:///modules/monit/listen_laravel_restart',
        owner  => root,
        group  => root,
        mode   => '0750',
    }

    file {'/etc/monit.d/listen_laravel_start':
        ensure => file,
        source => 'puppet:///modules/monit/listen_laravel_start',
        owner  => root,
        group  => root,
        mode   => '0750',
    }

    file {'/etc/monit.d/listen_laravel_stop':
        ensure => file,
        source => 'puppet:///modules/monit/listen_laravel_stop',
        owner  => root,
        group  => root,
        mode   => '0750',
    }

}
