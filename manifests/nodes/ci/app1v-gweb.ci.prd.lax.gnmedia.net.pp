node 'app1v-gweb.ci.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project='crowdignite'
    include common::app
    include httpd

    httpd::virtual_host{'ci.gweb.gnmedia.net':}

    common::nfsmount { '/app/log':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_prd_app_log/app1v-gweb.ci.prd.lax.gnmedia.net',
    }

    common::nfsmount { '/app/data/backup':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_prd_app_gweb/gweb-data',
    }
}
