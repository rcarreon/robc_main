# php 54 ius redis class
class php::ius::redis inherits php::service_type {
    package { ['php54-pecl-redis']:
      ensure   => installed,
      notify   => Service[$service_type],
    }
}
