# monit for all puppet clients
class monit::puppet inherits monit {
    file {'/etc/monit.d/puppet.conf':
        ensure  => file,
        content => template('monit/puppet.erb'),
        notify  => Service['monit'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
}
