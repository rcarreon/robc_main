node 'app1v-tt.ap.stg.lax.gnmedia.net' {
    include base
    $project='adops'
        include triggertag::stg
        include php::ao

        # Mounts
        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_stg_app_log/app1v-tt.ap.stg.lax.gnmedia.net",
        }

        $ap_trigdb_user=decrypt("6/NW0eXxkNWQDLLAfcOaxw==")
        $ap_trigdb_pass=decrypt("GgCRk+f1/CNct1/sBkCGDW3zblH+l9OB8/gUXnL1bHo=")
        $ap_trigdb_vip="vip-sqlro-tags.ap.stg.lax.gnmedia.net"
#        $ap_cdn_user="adplatform@gorillanation.com"
#        $ap_cdn_pass=decrypt("j2GdmLwrcURmLxjl4rL1aA==")
# This was springboard creds:
#        $ap_cdn_user=decrypt('Znc41WieZ+YpJ8cgY0bHPbiEIDQjAYTozbv5FU3ZrJvmCsWqd//9Rfr1Rmy1snkd')
#        $ap_cdn_pass=decrypt('/0Fa9XjjSfVK5jtKsu5gvg==')
# These are non-expiring creds:
        $ap_cdn_user=decrypt('Y0d1iqtrx+cmm9/2LW2FpiUuj1Eu1kw3aqJr9hT2WTc=')
        $ap_cdn_pass=decrypt('en8ppWT0HQUyU4yBH/cCGkSx6E/K1HLKrmV6CetM7qg=')

        file { "/app/shared/docroots/triggertag.gorillanation.com/conf/triggertag.ini":
                content => template('adops/triggertag.ini.erb'),
                owner   => "root",
                group   => "root",
        }

        $ap_sitedb_user=decrypt("DFU/fXLodFh6cb5rzWcQf7Fo57ST5mLl52NnGTv78kk=")
        $ap_sitedb_pass =decrypt("TTl29wup/COOTBxJJgwezQ==")
        $ap_sitedb_vip="vip-sqlro-adops.ap.stg.lax.gnmedia.net"
        $ap_sitecdn_user="adplatform@gorillanation.com"
        $ap_sitecdn_pass=decrypt("j2GdmLwrcURmLxjl4rL1aA==")

        file { "/app/shared/docroots/siteanalytics.evolvemediametrics.com/conf/siteanalytics.ini":
                content => template('adops/siteanalytics.ini.erb'),
                owner   => "root",
                group   => "root",
        }

        # Crons
        cron { "triggertag":
            environment => "HOME=/app/shared/docroots/triggertag.gorillanation.com/htdocs/cron",
            user        => "apache",
            command     => "cd /app/shared/docroots/triggertag.gorillanation.com/htdocs && /usr/bin/php cron/jsgen.php",
            hour        => [1,3,5,7,9,11,13,15,17,19,21,23],
            minute      => 0,
        }

        cron { "siteanalytics":
            environment => "HOME=/app/shared/docroots/siteanalytics.evolvemediametrics.com/htdocs/cron",
            user        => "apache",
            command     => "cd /app/shared/docroots/siteanalytics.evolvemediametrics.com/htdocs && /usr/bin/php cron/gen_site_analytics.php",
            hour        => [1,3,5,7,9,11,13,15,17,19,21,23],
            minute      => 0,
        }
}
