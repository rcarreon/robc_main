# php 56u class
class php::php56u {
    if $service_type == '' {
      $service_type = httpd
    }

    if $service_type == 'httpd' {
      include $service_type
    }

    include yum::ius
    #NOTE: you must uninstall PHP 5.3 manually before installing 5.6. 'sudo yum remove php-common'
    package { ['php56u', 'php56u-common', 'php56u-gd', 'php56u-opcache', 'php56u-xml', 'php56u-pecl-memcache', 'php56u-mysqlnd']:
        ensure  => installed,
        notify  => Service[$service_type],
        require => Class['yum::ius'],
    }
}
