class collectd::server::packages inherits collectd::package{
    package {'collectd-rrdtool':
        ensure => present,
    }

    user {'rrdcached':
        ensure  => present,
        comment => 'rrdcached',
        uid     => 20038,
        gid     => 20038,
        home    => '/var/run/rrdcached',
        shell   => '/sbin/nologin',
        require => Group['rrdcached'],
    }

    group {'rrdcached':
        ensure => present,
        gid    => 20038,
    }

    file { '/var/run/rrdcached':
        ensure  => directory,
        owner   => rrdcached,
        group   => rrdcached,
        mode    => '0755',
        require => User['rrdcached'],
    }
}
