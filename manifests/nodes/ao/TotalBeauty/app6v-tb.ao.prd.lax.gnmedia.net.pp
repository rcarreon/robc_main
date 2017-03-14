node 'app6v-tb.ao.prd.lax.gnmedia.net' {
    include base
    $httpd='atomiconline-tb'
    $project="atomiconline"
    include common::app
    include httpd
    include subversion::client
    include squid::tb_conf

    class {'php::install': version => '5.3',}

    httpd::virtual_host { 'totalbeauty.com': expect => "e4ea8133a649aad124e80f99f8831005"}
    httpd::virtual_host { 'totalbeauty_ssl.com':}
    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/tb_shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app6v-tb.ao.prd.lax.gnmedia.net",
    }
   common::nfsmount { "/mnt/media-nfs":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/tb-media",
    }
    

   ##Squid  conf file 
	


}
