# usage

#        $httpd="crowdignite"
#        $project="crowdignite"
# optional $service_type  (default to httpd) use for 'notify' restart/reload service
#        $service_type="nginx"
#
#        $php_version="5.3.14"
#        class {'yum::php-ius': version =>$php_version}
#
#        include php_ius
#        include php_ius_memcached


class php::ius inherits php::service_type {
    if $service_type == '' {
        $service_type = httpd
    }

    if $service_type == 'httpd' {
        include $service_type
    }

    package { ['php54', 'php54-common', 'php54-pear', 'php54-pdo', 'php54-pecl-memcache', 'php54-xml', 'php54-mysql', 'php54-cli', 'php54-pecl-apc', 'php54-gd']:
            ensure  => installed,
            notify  => Service[$service_type],
    }

    file {'/var/www/tmp':
        ensure  => directory,
        owner   => 'apache',
        group   => 'apache',
        mode    => '0755',
    }

    if $phpenv == '' {
      file { '/etc/php.ini':
              ensure  => file,
              owner   => 'root',
              group   => 'root',
              mode    => '0644',
              content => template("php/php.ini-${project}.erb"),
              notify  => Service[$service_type],
              require => Package[$service_type];
          }
    } else {
      file { '/etc/php.ini':
              ensure  => file,
              owner   => 'root',
              group   => 'root',
              mode    => '0644',
              content => template("php/php.ini-${project}-${phpenv}.erb"),
              notify  => Service[$service_type],
              require => Package[$service_type];
          }
    }


    file { '/etc/php.d/apc.ini':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => [
          "puppet:///modules/php/${project}_apc.ini.${env}",
          "puppet:///modules/php/${project}_apc.ini",
        ],
        notify  => Service[$service_type],
    }
}
