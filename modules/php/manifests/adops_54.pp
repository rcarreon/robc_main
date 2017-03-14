# adops php 5.4
class php::adops_54 {
    include yum::ius

    case $::lsbmajdistrelease {
      6: {
          package { ['php54', 'php54-common', 'php54-mysql', 'php54-mssql', 'php54-soap', 'php54-pecl-memcache', 'php54-cli', 'php54-pecl-apc','php54-mcrypt']:
              ensure  => present,
              require => Class['yum::ius'],
          }
      }

      default: {
          notify { 'php::adops54 does not support your OS.': }
      }
    }

}
