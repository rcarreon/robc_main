node 'app2v-tt.ap.stg.lax.gnmedia.net' {
    include base
    $project='adops'
        include triggertag::stg
        include php::ao

        #$ap_trigdb_user=decrypt("6/NW0eXxkNWQDLLAfcOaxw==")
        #$ap_trigdb_pass=decrypt("I15w+Sdr4NDKLBeLrrwuNQ==")
        #$ap_trigdb_vip="vip-sqlro-ap.ap.stg.lax.gnmedia.net"
        #$ap_cdn_user=decrypt("ai0c8QFHBOn4t5vIFEqaDEiTeJdJDaLV6cWSvF3+WEw=")
        #$ap_cdn_pass=decrypt("vEjZCUOu5dm3p6vOeMH+9w==")

        #file { "/app/shared/docroots/triggertag.gorillanation.com/conf/triggertag.ini":
        #content => template('adops/triggertag.ini.erb'),
        #}

        #$ap_sitedb_user=decrypt("DFU/fXLodFh6cb5rzWcQf7Fo57ST5mLl52NnGTv78kk=")
        #$ap_sitedb_pass =decrypt("xNNURmiTED4sfNW8UdOe5w==")
        #$ap_sitedb_vip="vip-sqlro-ap.ap.stg.lax.gnmedia.net"
        #$ap_sitecdn_user=decrypt("ai0c8QFHBOn4t5vIFEqaDEiTeJdJDaLV6cWSvF3+WEw=")
        #$ap_sitecdn_pass=decrypt("vEjZCUOu5dm3p6vOeMH+9w==")

        #file { "/app/shared/docroots/siteanalytics.evolvemediametrics.com/conf/siteanalytics.ini":
        #content => template('adops/siteanalytics.ini.erb'),
        #}

        common::nfsmount { "/app/log":
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_stg_app_log/app2v-tt.ap.stg.lax.gnmedia.net",
        }
}
