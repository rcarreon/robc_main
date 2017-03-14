node 'pxy1v-vb.ao.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        include sysctl
        include security

        $project="vb53u"

        varnish::accelerates {"vb":
            version => "c6_2_1_5_5",
        }

        common::nfsmount { "/pxy/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_pxy_log/pxy1v-vb.ao.stg.lax.gnmedia.net",
        }
}
