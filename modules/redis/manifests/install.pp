# Class: redis::install

class redis::install {
    group { 'redis':
        ensure  => 'present',
        gid     => '111',
    }

    user { 'redis':
        ensure   => 'present',
        password => '!!',
        uid      => '111',
        gid      => '111',
        comment  => 'Redis daemon',
        home     => '/var/lib/redis',
        shell    => '/sbin/nologin',
        require  => Group['redis'],
    }

    package { 'redis' :
        ensure   => installed,
        require  => [User[redis],Group[redis]]
    }
    file { '/var/redis':
        ensure   => directory,
        owner    => 'redis',
        require  => Package['redis'],
        group    => 'redis',
        mode     => '0755',
    }

    file { '/var/log/redis':
        ensure   => directory,
        owner    => 'redis',
        require  => Package['redis'],
        group    => 'redis',
        mode     => '0755',
    }
}
