# php 54 ius xdebug
class php::ius::xdebug {
    package { 'php54-pecl-xdebug':
        ensure => installed,
    }
}
