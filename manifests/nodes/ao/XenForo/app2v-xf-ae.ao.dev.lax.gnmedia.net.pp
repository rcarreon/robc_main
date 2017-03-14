node 'app2v-xf-ae.ao.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="atomiconline"
    include common::app
    include httpd
    include mysqld56::client
    include subversion::client
    class { 'php::install': }

    httpd::virtual_host { 'forums.afterellen.com': }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_shared/xf-ae-shared",
    }

    common::nfsmount { "/app/log":
	device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_dev_app_log/app2v-xf-ae.ao.dev.lax.gnmedia.net",
    }

    common::nfsmount { '/app/ugcfae':
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_dev_app_ugc/xf-ugc/forums.afterellen.com",
    }
}
