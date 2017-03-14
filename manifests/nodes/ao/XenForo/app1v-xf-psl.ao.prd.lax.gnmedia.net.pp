node 'app1v-xf-psl.ao.prd.lax.gnmedia.net' {
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

    httpd::virtual_host { 'forums.playstationlifestyle.net': expect => "c4568df34a4eab80a0d9879fe9bce549" }


#### Create Volumes
    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/xf-psl-shared",
    }

    common::nfsmount { "/app/log":
	device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app1v-xf-psl.ao.prd.lax.gnmedia.net",
    }

    common::nfsmount { '/app/ugcfpsl':
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_prd_app_ugc/xf-ugc/forums.playstationlifestyle.net",
    }


#### Create app directory structure
    file { ['/app/shared/xenforo_psl',
        '/app/shared/xenforo_psl/dbcred',
        '/app/shared/xenforo_psl/releases']:
             ensure => directory,
             owner   => deploy,
             group   => deploy,
             mode    => 755,
             require => Mount["/app/shared"],
             }


#### Create forums.playstationlifestyle.net prd dbcred file
  $prdpbxf_forums_pslro=decrypt("rvBPa3nb7H+5Fo97+30vnQ==")
  $prdpbxf_forums_pslrw=decrypt("yWtOTw9AynK0gHsihARr2Q==")
    file { "/app/shared/xenforo_psl/dbcred/db_forums.playstationlifestyle.net.php":
         content => template('atomiconline/prd_db_forums.playstationlifestyle.net.php'),
         }



}
