# Class: geoip_plugin
#
# This module manages geoip by country code
# - Installation
# - Service configuration
#

class geoip_plugin {
    file {'/etc/GeoIP.conf':
        source  => 'puppet:///modules/geoip_plugin/GeoIP.conf',
        require => Package['GeoIP'],
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }

    package {'GeoIP':
        ensure => installed,
    }

    package {'GeoIP-Plugin':
        ensure => installed,
    }
}
