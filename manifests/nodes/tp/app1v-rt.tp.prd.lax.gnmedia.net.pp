node 'app1v-rt.tp.prd.lax.gnmedia.net' {
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

        include sendmail::rt

        $rt_url = 'rt.gorillanation.com'
        httpd::virtual_host {'qt.gorillanation.com':}
        httpd::virtual_host {'qt2.gorillanation.com':}
        package {'perl-JSON':
            ensure => installed,
        }
        package {'git':
            ensure => installed,
        }


        include rt

        rt::config::rt_vhost {"$rt_url": db_host => "vip-sqlrw-rt.tp.prd.lax.gnmedia.net", db_user => "rt_user_rw", db_pass => "9Aul4dlQ", sso => true,}

       common::nfsmount { "/app/shared":
           device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_shared/rt-shared",
       }

       common::nfsmount { "/app/log":
           device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_log/app1v-rt.tp.prd.lax.gnmedia.net",
       }

       common::nfsmount {"/app/tmp":
           device => "nfsB-netapp1.gnmedia.net:/vol/nac1b_tp_lax_prd_app_tmp",
       }


}
