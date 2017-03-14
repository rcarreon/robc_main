node 'app2v-tt.ap.prd.lax.gnmedia.net' {
    include base
    $project='adops'
        include triggertag::prd
        include php::ao

        common::nfsmount { "/app/log":
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_prd_app_log/app2v-tt.ap.prd.lax.gnmedia.net",
        }
}
