node 'app2v-corp.si.prd.lax.gnmedia.net' {
    include base
    $project="corp"
    include common::app
    include si::corp_sites
    include doublehelix::commonconfig::prd
    include newrelic       
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat


    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_si_lax_prd_app_shared/corp-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_si_lax_prd_app_log/app2v-corp.si.prd.lax.gnmedia.net",
    }
}
