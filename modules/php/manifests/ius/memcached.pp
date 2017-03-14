# php 54 ius memcached class
class php::ius::memcached inherits php::service_type {
    package { ['libmemcached10', 'php54-pecl-memcached', 'php54-pecl-igbinary']:
      ensure   => installed,
      notify   => Service[$service_type],
    }
    file { '/etc/php.d/memcached.ini':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => [
                        "puppet:///modules/php/${project}_memcached.ini",
                        'puppet:///modules/php/memcached.ini',
                    ],
        require => Package['libmemcached10', 'php54-pecl-memcached'];
    }
}
