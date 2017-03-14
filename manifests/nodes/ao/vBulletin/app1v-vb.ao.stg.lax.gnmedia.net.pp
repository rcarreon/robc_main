node 'app1v-vb.ao.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $httpd="vb53u"
        $project="vb53u"
        include common::app
        include sysctl
        include security
        class { 'php::install': }
        include subversion::client

        httpd::virtual_host {"hfboards.hockeysfuture.com": monitor => false,}
        httpd::virtual_host {"babyandbump.momtastic.com": monitor => false,}
        httpd::virtual_host {"forums.sherdog.com": monitor => false,}

        file { "/etc/httpd/conf.d/sherdog.net.logins":
                source => "puppet:///modules/httpd/htpasswords/atomic-sites/sherdog.logins",
                owner  => "deploy",
                group  => "deploy",
        }

        file { "/etc/httpd/conf.d/forums.sherdog.com.logins":
                source => "puppet:///modules/httpd/htpasswords/atomic-sites/forums.sherdog.com.logins",
                owner  => "deploy",
                group  => "deploy",
        }

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_shared/vb-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_log/app1v-vb.ao.stg.lax.gnmedia.net",
        }

}
