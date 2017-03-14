
class memcached {

    include collectd::plugins::memcached

    group { 'memcached':
        ensure  => 'present',
        gid     => '115',
    }

    user { 'memcached':
        uid             => '115',
        gid             => '115',
        comment         => 'Memcached daemon',
        home            => '/var/run/memcached',
        shell           => '/sbin/nologin',
        ensure          => 'present',
        require         => Group['memcached'],
        system          => true,
    }

    package { 'memcached':
        ensure  => present,
        require => [User[memcached], Group[memcached]]
    }
 
    # Needed for munin pluginis
    package { 'perl-Net-Telnet':
        ensure => present,
    }

    # Needed for flushing memcache
    package { 'nc':
        ensure => present,
    }

    # Main config
    if $site {
        file{'/etc/sysconfig/memcached':
            content => template("memcached/${project}/${site}.conf.erb"),
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            # notify  => Service["memcached"];
        }
    } else {
        file{'/etc/sysconfig/memcached':
            content => template("memcached/${project}.conf.erb"),
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            # shouldn't restart memcache by puppet.  this could slam sql :(
            # notify  => Service["memcached"];
        }
    }


    service{'memcached':
        enable    => true,
        ensure    => running,
        hasstatus => true,
        require   => Package[memcached],
    }

    nagios::service {'memcached':
        command   => 'check_memcache',
        notes_url => 'http://docs.gnmedia.net/wiki/Nagios-memcache',
    }

    nagios::service {'memcached_connection':
        command   => 'check_memcached_connection',
        notes_url => 'http://docs.gnmedia.net/wiki/Nagios-memcache',
    }

    nagios::service {'memcached_memory':
        command   => 'check_memcached_memory',
        notes_url => 'http://docs.gnmedia.net/wiki/Nagios-memcache',
    }

    if( $fqdn !~ /mem\d+v-ci.ci.prd.lax.gnmedia.net/ ) {
        nagios::service {'memcached_eviction':
            command     => 'check_memcached_eviction',
            notes_url   => 'http://docs.gnmedia.net/wiki/Nagios-memcache',
        }
    }
}
