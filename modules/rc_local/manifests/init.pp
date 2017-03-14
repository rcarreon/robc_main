# The rc_local class was previously named rc-local
class rc_local {
    package { 'initscripts':
        ensure => installed,
    }

    file { '/etc/rc.d/rc.local':
        ensure  => 'file',
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template('rc_local/rc.local.erb'),
        require => Package['initscripts'],
    }

    file { '/etc/rc.local':
        ensure  => link,
        target  => '/etc/rc.d/rc.local',
        require => File['/etc/rc.d/rc.local'],
    }
}
