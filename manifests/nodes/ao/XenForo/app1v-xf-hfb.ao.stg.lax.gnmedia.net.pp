node 'app1v-xf-hfb.ao.stg.lax.gnmedia.net' {
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

#### Create Volumes
    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_shared/xf-hfb-shared",
    }

    common::nfsmount { "/app/log":
	device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_stg_app_log/app1v-xf-hfb.ao.stg.lax.gnmedia.net",
    }

    common::nfsmount { '/app/ugcfhfb':
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_stg_app_ugc/xf-ugc/hfboards.hockeysfuture.com",
    }


#### Create app directory structure
    file { ['/app/shared/xenforo_hfb',
        '/app/shared/xenforo_hfb/dbcred',
        '/app/shared/xenforo_hfb/releases']:
             ensure => directory,
             owner   => deploy,
             group   => deploy,
             mode    => 755,
             require => Mount["/app/shared"],
             }


#### Create hfboards.hockeysfuture.com stg dbcred file
  $stgpbxf_forums_hfbro=decrypt("R3NGf1ht5Ss2gCcnO49UjA==")
  $stgpbxf_forums_hfbrw=decrypt("2k5Z5fTrSWvl/r5K14pn3Q==")
    file { "/app/shared/xenforo_hfb/dbcred/db_hfboards.hockeysfuture.com.php":
         content => template('atomiconline/stg_db_hfboards.hockeysfuture.com.php'),
         }


}
