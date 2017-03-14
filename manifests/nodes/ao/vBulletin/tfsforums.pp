
class tfsforums_webserver {
        #include httpd
        httpd::virtual_host {"forums.thefashionspot.com":}
        include php::tfs
        include subversion::client

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/tfs-shared",
        }
        common::nfsmount { "/app/ugc":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/tfs-ugc",
        }

	file { "/etc/httpd/conf.d/forums.tfs.logins":
                source => "puppet:///modules/httpd/htpasswords/atomic-sites/forums.tfs.logins",
                owner   => "deploy",
                group   => "deploy",
        }
}



