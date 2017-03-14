node 'app4v-vb.ao.prd.lax.gnmedia.net' {
    $httpd="vb53u"
    $project="vb53u"

    include base
    include common::app
    include php::php53u::normal
    include subversion::client
    include sysctl
    include sendmail::use_gateway

        httpd::virtual_host {"forums.sherdog.com":}
        httpd::virtual_host {"hfboards.hockeysfuture.com":}
        httpd::virtual_host {"babyandbump.momtastic.com":}

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
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/vb-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app4v-vb.ao.prd.lax.gnmedia.net",
        }

        common::nfsmount { "/app/ugc/vb_bab":
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_prd_app_ugc/vb-bab-ugc/vb_bab",
        }

        common::nfsmount { "/app/ugc/vb_hfb":
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_prd_app_ugc/vb-hfb-ugc/vb_hfb",
        }

        common::nfsmount { "/app/ugc/vb_sdc":
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_prd_app_ugc/vb-sdc-ugc/vb_sdc",
        }
}
