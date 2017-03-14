node 'app1v-xf-wz.ao.dev.lax.gnmedia.net' {
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

#### Create volumes
    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_shared/xf-wz-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_log/app1v-xf-wz.ao.dev.lax.gnmedia.net",
    }

    common::nfsmount { '/app/ugcfwz':
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_dev_app_ugc/xf-ugc/forums.wrestlezone.com",
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

#### Create forums.wrestlezone.com dev dbcred file
  $devpbxf_forums_wzro=decrypt("uOH5GTtK4AqewYDdeJHtFQ==")
  $devpbxf_forums_wzrw=decrypt("Fn3X34zH4k696YcLPPEPzA==")
    file { "/app/shared/xenforo_wz/dbcred/db_forums.wrestlezone.com.php":
         content => template('atomiconline/dev_db_forums.wrestlezone.com.php'),
         }

}