#
# Usage:
# include php::lite_php_browscap
#

class php::lite_php_browscap  {

    file { '/etc/lite_php_browscap.ini':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/php/lite_php_browscap.ini',
    }
}
