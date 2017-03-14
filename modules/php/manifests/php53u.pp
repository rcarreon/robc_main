# php 53u class
class php::php53u {
    if $service_type == '' {
      $service_type = httpd
    }

    if $service_type == 'httpd' {
      include $service_type
    }

    include yum::ius
    #NOTE: you must uninstall PHP 5.1 manually before installing 5.3. 'sudo yum remove php-common'
    package { ['php53u', 'php53u-common', 'php53u-gd', 'php53u-xml', 'php53u-pecl-memcache', 'php53u-mysql']:
        ensure  => installed,
        notify  => Service[$service_type],
        require => Class['yum::ius'],
    }
}
