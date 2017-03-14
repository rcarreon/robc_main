node 'app3v-xf-sdc.ao.prd.lax.gnmedia.net' {
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
    include php::iusxf

    httpd::virtual_host { 'forums.sherdog.com': }


#### Create Volumes
    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/xf-sdc-shared",
    }

    common::nfsmount { "/app/log":
	device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app3v-xf-sdc.ao.prd.lax.gnmedia.net",
    }

    common::nfsmount { '/app/ugcfsdc':
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_prd_app_ugc/xf-ugc/forums.sherdog.com",
    }


#### Create app directory structure
    file { ['/app/shared/xenforo_sdc',
        '/app/shared/xenforo_sdc/dbcred',
        '/app/shared/xenforo_sdc/releases']:
             ensure => directory,
             owner   => deploy,
             group   => deploy,
             mode    => 755,
             require => Mount["/app/shared"],
             }


#### Create forums.sherdog.com prd dbcred file
  $prdpbxf_forums_sdcro=decrypt("2JeHGwf3Mulq3o3G7hrOTQ==")
  $prdpbxf_forums_sdcrw=decrypt("l5p4EVMI+c85uulg3OUgHA==")
    file { "/app/shared/xenforo_sdc/dbcred/db_forums.sherdog.com.php":
         content => template('atomiconline/prd_db_forums.sherdog.com.php'),
         }



}
