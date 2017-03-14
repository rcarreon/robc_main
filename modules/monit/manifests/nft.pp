# monit for nft
class monit::nft inherits monit {

    file {'/etc/monit.d/nft.conf':
        ensure  => file,
        content => template('monit/nft.erb'),
        notify  => Service['monit'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
}
