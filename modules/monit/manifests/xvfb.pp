# monitor xvfb on jenkins slaves
class monit::xvfb inherits monit {
    file {'/etc/monit.d/xvfb.conf':
        ensure  => file,
        # require => Package['monit'],
        source  => 'puppet:///modules/monit/monit_xvfb',
        notify  => Service['monit'],
        mode    => '0755',
        owner   => 'deploy',
        group   => 'deploy',
    }
}
