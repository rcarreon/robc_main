node 'pxy2v-vb.ao.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="vb53u"

        varnish::accelerates {"vb53u":
            version => "c6_2_1_5_5",
        }

        common::nfsmount { "/pxy/log":
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_prd_pxy_log/pxy2v-vb.ao.prd.lax.gnmedia.net",
        }
}
