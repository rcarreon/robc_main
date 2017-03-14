node 'app1v-xf-hfb.ao.prd.lax.gnmedia.net' {
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
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/xf-hfb-shared",
    }

    common::nfsmount { "/app/log":
	device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app1v-xf-hfb.ao.prd.lax.gnmedia.net",
    }

    common::nfsmount { '/app/ugcfhfb':
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_prd_app_ugc/xf-ugc/hfboards.hockeysfuture.com",
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


#### Create hfboards.hockeysfuture.com prd dbcred file
  $prdpbxf_forums_hfbro=decrypt("an62CjB5wFDlc/zKP2YAYA==")
  $prdpbxf_forums_hfbrw=decrypt("1eKPmDA4/NQY0N9qDE23sg==")
    file { "/app/shared/xenforo_hfb/dbcred/db_hfboards.hockeysfuture.com.php":
         content => template('atomiconline/prd_db_hfboards.hockeysfuture.com.php'),
         }



}
