# Class: passenger
# This module manages passenger
#
# Sample Usage:
#

class passenger ( $conf_template = 'passenger.conf.erb' ) {
    include passenger::params
    include passenger::packages
    class { 'passenger::config': conf_template => $conf_template, }

    exec {'install-mod-passenger':
        command     => '/usr/bin/passenger-install-apache2-module -a',
        unless      => "/usr/bin/test -e ${passenger::params::mod_passenger_location}",
        subscribe   => Package['passenger'],
        require     => Class['passenger::config'],
    }

}
