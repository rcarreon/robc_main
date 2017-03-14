node 'app1v-xf-ae.ao.stg.lax.gnmedia.net' {
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

#### Create Volumes
    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_shared/xf-ae-shared",
    }

    common::nfsmount { "/app/log":
	device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_stg_app_log/app1v-xf-ae.ao.stg.lax.gnmedia.net",
    }

    common::nfsmount { '/app/ugcfae':
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_stg_app_ugc/xf-ugc/forums.afterellen.com",
    }


#### Create app directory structure
    file { ['/app/shared/xenforo_ae',
        '/app/shared/xenforo_ae/dbcred',
        '/app/shared/xenforo_ae/releases']:
             ensure => directory,
             owner   => deploy,
             group   => deploy,
             mode    => 755,
             require => Mount["/app/shared"],
             }


#### Create forums.afterellen.com stg dbcred file
  $stgpbxf_forums_aero=decrypt("ifMRKuCUjWjs5rxuZAqkJA==")
  $stgpbxf_forums_aerw=decrypt("5lDa4sZSV6Dp6LMjY6JHPA==")
    file { "/app/shared/xenforo_ae/dbcred/db_forums.afterellen.com.php":
         content => template('atomiconline/stg_db_forums.afterellen.com.php'),
         }


}
