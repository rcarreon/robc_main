# bind module
class bind {
    package {'bind':
        ensure => installed
    }

    service{'named':
        ensure    => running,
        enable    => true,
        hasstatus => true,
    }

    file { '/var/named':
        ensure  => directory,
        owner   => 'named',
        group   => 'deploy',
        mode    => '0775',
    }

    file { '/etc/bind':
        ensure  => directory,
        owner   => 'em-deploy',
        group   => 'em-deploy',
        mode    => '0755',
    }
    file { '/etc/named.conf':
        ensure => link,
        target => '/etc/bind/named.conf',
    }
    file { '/etc/named-slaves-generated.conf':
        ensure => link,
        target => '/etc/bind/named-slaves-generated.conf',
    }
    file { '/var/named/named.local':
        ensure => file,
        source => 'puppet:///modules/bind/named.local',
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
    }
    file { '/var/named/localhost.zone':
        ensure => file,
        source => 'puppet:///modules/bind/localhost.zone',
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
    }
    file { '/var/named/named.ca':
        ensure => absent
    }
    file { '/var/named/named.empty':
        ensure => absent
    }
    file { '/var/named/named.localhost':
        ensure => absent
    }
    file { '/var/named/named.loopback':
        ensure => absent
    }

    # These are only needed on masters
    file { '/app':
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }
    file { '/app/shared':
        ensure  => directory,
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0755',
    }
}
