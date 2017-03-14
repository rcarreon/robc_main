#
# Usage:
# include php::browscap
#
class php::browscap  {

    file { '/etc/php_browscap.ini':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/php/php_browscap.ini',
    }
}
