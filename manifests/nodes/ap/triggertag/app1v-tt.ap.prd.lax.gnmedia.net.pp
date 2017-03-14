node 'app1v-tt.ap.prd.lax.gnmedia.net' {
    include base
    $project='adops'
    include triggertag::prd
    include php::ao

    # Mounts
    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_log/app1v-tt.ap.prd.lax.gnmedia.net",
    }

    $ap_trigdb_user='triggertag_r'
    $ap_trigdb_pass=decrypt('4dK8cSPFquUoexYwYzVuaA==')

    $ap_trigdb_vip='vip-sqlro-tags.ap.prd.lax.gnmedia.net'

    # these were triggertag akamai creds (sbv)
    #$ap_cdn_user=decrypt('Znc41WieZ+YpJ8cgY0bHPbiEIDQjAYTozbv5FU3ZrJvmCsWqd//9Rfr1Rmy1snkd')
    #$ap_cdn_pass=decrypt('/0Fa9XjjSfVK5jtKsu5gvg==')

    # These are triggertag non-expiring akamai creds:
    $ap_cdn_user=decrypt('Y0d1iqtrx+cmm9/2LW2FpiUuj1Eu1kw3aqJr9hT2WTc=')
    $ap_cdn_pass=decrypt('en8ppWT0HQUyU4yBH/cCGkSx6E/K1HLKrmV6CetM7qg=')

    file { '/app/shared/docroots/triggertag.gorillanation.com/conf/triggertag.ini':
        ensure  => file,
        content => template('adops/triggertag-prod.ini.erb'),
        owner   => 'root',
        group   => 'root',
    }

    # these are used for siteanalytics
    $ap_sitedb_user='siteanalytics_r'
    $ap_sitedb_pass=decrypt('Fua9w0s4/ni64k/qDMSJgA==')

    $ap_sitedb_vip='vip-sqlro-adops.ap.prd.lax.gnmedia.net'
    $ap_sitecdn_user='adplatform@gorillanation.com'
    $ap_sitecdn_pass=decrypt('DbNJ8q06w9ZcydAk4nbYnQ8Q4bvH49ncI6hzR4xh+BdhbrRH9rH+UtJfKqL74gNS')

    file { '/app/shared/docroots/siteanalytics.evolvemediametrics.com/conf/siteanalytics.ini':
        ensure  => file,
        content => template('adops/siteanalytics-prod.ini.erb'),
        owner   => 'root',
        group   => 'root',
    }

    # Crons
    cron { 'triggertag':
        environment => 'HOME=/app/shared/docroots/triggertag.gorillanation.com/htdocs/cron',
        user        => 'apache',
        command     => 'cd /app/shared/docroots/triggertag.gorillanation.com/htdocs && /usr/bin/php cron/jsgen.php',
        hour        => '*',
        minute      => '0',
    }

    cron { 'siteanalytics':
        environment => 'HOME=/app/shared/docroots/siteanalytics.evolvemediametrics.com/htdocs/cron',
        user        => 'apache',
        command     => 'cd /app/shared/docroots/siteanalytics.evolvemediametrics.com/htdocs && /usr/bin/php cron/gen_site_analytics.php',
        hour        => '*',
        minute      => 0,
    }

}
