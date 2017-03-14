node 'app1v-mdbdt.ao.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="admin"

    common::nfsmount { "/sql/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_mdbdt_ao_prd_log/app1v-mdbdt.ao.prd.lax.gnmedia.net",
    }

    common::nfsmount { "/sql/data":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_app1v_mdbdt_ao_prd_lax_mongo_data",
    }

}
