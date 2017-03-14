node 'app1v-tt.ap.dev.lax.gnmedia.net' {
    include base
    $project='adops'
    include triggertag::dev
    include php::ao

    # Mounts


    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_log/app1v-tt.ap.dev.lax.gnmedia.net",
    }

    $ap_trigdb_user="triggertag_r"
    $ap_trigdb_pass=decrypt("2/A+U0s70qoxKkYeyqoRfw==")
    $ap_trigdb_vip="sql1v-56-tags.ap.dev.lax.gnmedia.net"
    $ap_cdn_user="this will fail"
    $ap_cdn_pass="this will fail"

    file { "/app/shared/docroots/triggertag.gorillanation.com/conf/triggertag.ini":
        content => template('adops/triggertag.ini.erb'),
        owner   => "root",
        group   => "root",
    }

    $ap_sitedb_user="siteanalytics_r"
    $ap_sitedb_pass =decrypt("YAa6xdvDuj26ystdHlY27g==")
    $ap_sitedb_vip="sql1v-56-adops.ap.dev.lax.gnmedia.net"
    $ap_sitecdn_user="this will fail"
    $ap_sitecdn_pass="this will fail"

    file { "/app/shared/docroots/siteanalytics.evolvemediametrics.com/conf/siteanalytics.ini":
        content => template('adops/siteanalytics.ini.erb'),
        owner   => "root",
        group   => "root",
    }
}
