node 'pxy3v-vb.ao.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    $project="vb53u"

    include base

    varnish::accelerates {"vb53u":
        version => "c6_2_1_5_5",
    }

    common::nfsmount { "/pxy/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_pxy_log/pxy3v-vb.ao.prd.lax.gnmedia.net",
    }
}
