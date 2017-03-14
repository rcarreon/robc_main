node 'app1v-xf-ae.ao.dev.lax.gnmedia.net' {
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

#### Create volumes
    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_shared/xf-ae-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_log/app1v-xf-ae.ao.dev.lax.gnmedia.net",
    }

    common::nfsmount { '/app/ugcfae':
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_dev_app_ugc/xf-ugc/forums.afterellen.com",
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

#### Create forums.afterellen.com dev dbcred file
  $devpbxf_forums_aero=decrypt("FMIsOqSC/iDQcam3f+N7qw==")
  $devpbxf_forums_aerw=decrypt("iugcEZsdMAMUx/tK2OpPGg==")
    file { "/app/shared/xenforo_ae/dbcred/db_forums.afterellen.com.php":
         content => template('atomiconline/dev_db_forums.afterellen.com.php'),
         }

}
