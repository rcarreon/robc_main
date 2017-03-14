# php 51 class
class php::php51 {
    include httpd
    package { ['php', 'php-common', 'php-gd', 'php-xml', 'php-pecl-memcache', 'php-mysql']:
        ensure => installed,
        notify => Service[httpd],
    }
}
