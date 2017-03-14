# php adops_memcache class
class php::adops_memcache ($memcache_servers) {
    file {'/etc/php.d/memcache.ini':
        content => template('php/adops/adops3_memcache.ini.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
}
