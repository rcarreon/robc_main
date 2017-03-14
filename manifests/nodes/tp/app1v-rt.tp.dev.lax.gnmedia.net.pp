node 'app1v-rt.tp.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="admin"
        include httpd
        include common::app
        include subversion::client
        include sysctl

        include sendmail::rtdev

        $rt_url = 'dev.rt.gorillanation.com'
        httpd::virtual_host {'qt.gorillanation.com':}
        httpd::virtual_host {'qt2.gorillanation.com':}
        package {'perl-JSON':
            ensure => installed,
        }
        package {'git':
            ensure => installed,
        }


        include rt

        rt::config::rt_vhost {"$rt_url": db_host => "sql1v-56-rt.tp.dev.lax.gnmedia.net", db_user => "rt_user_rw", db_pass => "Hurlushchec6", sso => true,}

       common::nfsmount { "/app/shared":
           device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_app_shared/rt-shared",
       }


}
