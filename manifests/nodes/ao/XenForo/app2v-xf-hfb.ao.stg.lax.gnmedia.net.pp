node 'app2v-xf-hfb.ao.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="atomiconline"
    include common::app
    include httpd
    include mysqld56::client
    include git::client
    include yum::ius
    include php::ius
    include php::ius::mcrypt

    httpd::virtual_host { 'hfboards.hockeysfuture.com': }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_shared/xf-hfb-shared",
    }

    common::nfsmount { "/app/log":
	device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_stg_app_log/app2v-xf-hfb.ao.stg.lax.gnmedia.net",
    }

    common::nfsmount { '/app/ugcfhfb':
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_stg_app_ugc/xf-ugc/hfboards.hockeysfuture.com",
    }
}
