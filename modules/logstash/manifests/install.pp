class logstash::install {
    include yum::gnrepo
    package {'logstash':
        ensure  => present,
        require => [User['logstash'],Group['logstash']],
    }
    package {'java-1.7.0-openjdk':
        ensure  => present,
    }

    user {'logstash':
        password => '!!',
        uid      => '118',
        gid      => '118',
        comment  => 'logstash daemon',
        home     => '/usr/share/java/logstash',
        shell    => '/sbin/nologin',
        ensure   => 'present',
        require  => [Group['logstash']],
    }

    group {'logstash':
        ensure => present,
        gid    => '118',
    }
}


