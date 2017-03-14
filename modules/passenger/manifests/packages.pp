# Class: passenger::packages
# This module manages passenger packages
#
# Sample Usage:
#

# install packages for passenger
class passenger::packages{
    include passenger::params
    include rubygems::rake
    include rubygems::rack
    include httpd
    include ruby::devel

    package { 'passenger':
        ensure   => $passenger::params::version,
        provider => gem,
        require  => [Class['rubygems::rake'], Class['rubygems::rack'], Package['httpd-devel'], Package['mod_ssl'], Package['gcc'], Package['gcc-c++']],
    }

    package { ['httpd-devel', 'mod_ssl', 'gcc', 'gcc-c++']:
        ensure  => installed,
        require => Class['httpd'],
    }

    # we don't need libcurl-devel on the puppet and dashboard servers
    if ($::lsbmajdistrelease == '6') {
        package { ['libcurl-devel', 'openssl-devel', 'zlib-devel']:
            ensure => installed,
        }
    }

}
