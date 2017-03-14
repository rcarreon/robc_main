node 'app1v-tb.ao.dev.lax.gnmedia.net' {
    include base
    $project="atomiconline"
    include common::app
    include httpd
    include subversion::client
    class {'php::install': version => '5.3',}

    httpd::virtual_host { 'totalbeauty.com': monitor => false,}

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_shared/tb_shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_log/app1v-tb.ao.dev.lax.gnmedia.net",
    }
}