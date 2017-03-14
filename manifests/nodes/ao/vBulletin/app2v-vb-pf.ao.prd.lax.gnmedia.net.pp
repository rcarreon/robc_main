node 'app2v-vb-pf.ao.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="vb"

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/vb-pf-shared",
    }

    common::nfsmount { "/app/ugc":
      device => "nfsA-netapp1.gnmedia.net:/vol/nac1b_ao_lax_prd_app_ugc/vb-pf-ugc",
    }

    common::nfsmount { "/app/log":
      device => "nfsA-netapp1.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app2v-vb-pf.ao.prd.lax.gnmedia.net",
    }
}
