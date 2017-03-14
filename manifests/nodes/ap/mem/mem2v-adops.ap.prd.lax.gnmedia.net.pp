node 'mem2v-adops.ap.prd.lax.gnmedia.net' {
    include base
    $project="adops"
    include memcached

    # enable memcached stats in ganglia
    exec { 'enable_ganglia_memcached.pyconf':
        command => '/bin/mv /etc/ganglia/conf.d/memcached.pyconf.disabled /etc/ganglia/conf.d/memcached.pyconf',
        creates => '/etc/ganglia/conf.d/memcached.pyconf'
    }

}
