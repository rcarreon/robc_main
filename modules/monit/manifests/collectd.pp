# collectd monit class
class monit::collectd inherits monit {
    file {'/etc/monit.d/collectd.conf':
        ensure  => absent,
        content => template('monit/collectd.erb'),
        notify  => Service['monit'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
}
