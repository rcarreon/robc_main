# puppet-lint made me do this
class php::ao_gr {
    class {'php::install': version => '5.1', ini_template => 'atomiconline/php.ini-51.ao-gr.erb', extra_packages => ['php-devel', 'php-pdo', 'php-pear', 'php-xmlrpc']}
    file { '/etc/php.d/memcache.ini':
        ensure   => file,
        owner    => 'root',
        group    => 'root',
        mode     => '0644',
        content  => template('php/atomiconline/php.memcache.ini.ao-gr.erb'),
    }
}
