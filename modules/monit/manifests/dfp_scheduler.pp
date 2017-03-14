# alert if the dfp_scheduler has gotten stuck
class monit::dfp_scheduler inherits monit {

    file {'/etc/monit.d/dfp_scheduler.conf':
        ensure  => file,
        content => template('monit/dfp_scheduler.erb'),
        notify  => Service['monit'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

}
