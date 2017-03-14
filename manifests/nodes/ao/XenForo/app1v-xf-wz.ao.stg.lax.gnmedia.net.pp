node 'app1v-xf-wz.ao.stg.lax.gnmedia.net' {
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

    httpd::virtual_host { 'forums.wrestlezone.com': }

#### Create Volumes
    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_shared/xf-wz-shared",
    }

    common::nfsmount { "/app/log":
	device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_stg_app_log/app1v-xf-wz.ao.stg.lax.gnmedia.net",
    }

    common::nfsmount { '/app/ugcfwz':
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_stg_app_ugc/xf-ugc/forums.wrestlezone.com",
    }


#### Create app directory structure
    file { ['/app/shared/xenforo_wz',
        '/app/shared/xenforo_wz/dbcred',
        '/app/shared/xenforo_wz/releases']:
             ensure => directory,
             owner   => deploy,
             group   => deploy,
             mode    => 755,
             require => Mount["/app/shared"],
             }


#### Create forums.wrestlezone.com stg dbcred file
  $stgpbxf_forums_wzro=decrypt("jj0auzrM/RF1qus4AGzo4Q==")
  $stgpbxf_forums_wzrw=decrypt("d8EO8tR3JboxWjMypH8o0A==")
    file { "/app/shared/xenforo_wz/dbcred/db_forums.wrestlezone.com.php":
         content => template('atomiconline/stg_db_forums.wrestlezone.com.php'),
         }


}
