node 'app1v-xf-psl.ao.dev.lax.gnmedia.net' {
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

    httpd::virtual_host { 'forums.playstationlifestyle.net': }

#### Create volumes
    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_shared/xf-psl-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_log/app1v-xf-psl.ao.dev.lax.gnmedia.net",
    }

    common::nfsmount { '/app/ugcfpsl':
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_dev_app_ugc/xf-ugc/forums.playstationlifestyle.net",
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

#### Create forums.playstationlifestyle.net dev dbcred file
  $devpbxf_forums_pslro=decrypt("UWppaBVE2gdIAtVbUOMuxQ==")
  $devpbxf_forums_pslrw=decrypt("oyFdMEiH/ePN6S9+cO0pCw==")
    file { "/app/shared/xenforo_psl/dbcred/db_forums.playstationlifestyle.net.php":
         content => template('atomiconline/dev_db_forums.playstationlifestyle.net.php'),
         }

}
