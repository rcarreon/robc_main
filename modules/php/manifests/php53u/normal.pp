# php53u normal class
class php::php53u::normal inherits php::php53u {

  if $service_type == 'httpd' {
    file { '/var/www/tmp':
      ensure  => directory,
      owner   => 'apache',
      group   => 'apache',
      mode    => '0755',
    }
  } else {
    file { '/var/www/tmp':
      ensure  => directory,
      owner   => $service_type,
      group   => $service_type,
      mode    => '0755',
    }
  }

  file { '/etc/php.ini':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template("php/php.ini-${project}.erb"),
        notify  => Service[$service_type],
        require => Package[$service_type],
    }

    package { 'php53u-pecl-apc.x86_64':
        ensure  => present,
    }

    file { '/etc/php.d/apc.ini':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => "puppet:///modules/php/${project}_apc.ini",
        notify  => Service[$service_type],
    }

    file { '/etc/php.d/memcache.ini':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => "puppet:///modules/php/${project}_memcache.ini",
        notify  => Service[$service_type],
    }
}
