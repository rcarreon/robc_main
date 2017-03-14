# Class: php::install
#
# This class is a wrapper to install different PHP versions
#
# Parameters:
# * version - version number string in {major}.{minor} format
# * ini_template - ini template string (optional)
# * extra_packages - array of package names to install (optional)
#
# Actions:
# Installs PHP
#
# Requires:
# * php53u
# * php51
#
# Sample Usage:
# class {'php::install': version => '5.3', ini_template => 'project/php.ini.erb', extra_packages => ['php53u-tidy', 'php53u-pear']}

# TODO: Rename this class to 'php'
class php::install( $version = '', $ini_template='', $extra_packages=[]) {
    case $::lsbmajdistrelease {
        5: {
                case $version {
                    '5.3':    { include php::php53u }
                    '5.1':    { include php::php51 }
                    '5.6':    { include php::php56u }
                    default: { err('Invalid PHP version parameter') }
                }
        }
        6: {
		        case $version {
		            '5.6':    { include php::php56u }
                    default: { include php }
                }
        }
        default: {
            notify { 'there is no default ::lsbmajdistrelase... php::install does not approve': }
        }
    }

    if $ini_template != '' {
        file { '/etc/php.ini':
            ensure  => file,
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => template("php/${ini_template}"),
            notify  => Service[httpd],
            require => Package['httpd'];
        }
    }

    # install extra packages
    package { $extra_packages:
        ensure => present,
    }
}
