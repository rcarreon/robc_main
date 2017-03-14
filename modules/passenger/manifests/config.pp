# Class: passenger::config
#
# Sample Usage:
#

# class to manage configuration files for passenger
class passenger::config ( $conf_template = 'passenger.conf.erb' ) {
    file { '/etc/httpd/conf.d/passenger.conf':
        content => template("passenger/$conf_template"),
        require => Class['passenger::packages'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
}
