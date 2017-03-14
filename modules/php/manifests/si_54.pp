# si php 5.4
class php::si_54 {
    include yum::ius

    case $::lsbmajdistrelease {
      6: {
          package { ['php54',
                     'php54-cli',
                     'php54-common',
                     'php54-fpm',
                     'php54-gd',
                     'php54-intl',
                     'php54-mbstring',
                     'php54-mcrypt',
                     'php54-pdo',
                     'php54-pear',
                     'php54-pecl-igbinary',
                     'php54-pecl-imagick',
                     'php54-pecl-memcache',
                     'php54-pecl-memcached',
                     'php54-pecl-xdebug',
                     'php54-pgsql',
                     'php54-soap',
                     'php54-mysql',
                     'php54-xml',]:
              ensure  => present,
              require => Class['yum::ius'],
          }
      }

      default: {
          notify { 'php::si_54 does not support your OS.': }
      }
    }

}
