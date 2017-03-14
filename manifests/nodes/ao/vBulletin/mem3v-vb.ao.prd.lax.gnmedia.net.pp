node 'mem3v-vb.ao.prd.lax.gnmedia.net' {
    $project="vb53"

    include base
    include memcached
    include sysctl

}
