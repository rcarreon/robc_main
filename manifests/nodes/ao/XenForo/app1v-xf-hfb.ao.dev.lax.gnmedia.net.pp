node 'app1v-xf-hfb.ao.dev.lax.gnmedia.net' {
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

#### Create volumes
    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_shared/xf-hfb-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_log/app1v-xf-hfb.ao.dev.lax.gnmedia.net",
    }

    common::nfsmount { '/app/ugcfhfb':
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_dev_app_ugc/xf-ugc/hfboards.hockeysfuture.com",
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

#### Create hfboards.hockeysfuture.com dev dbcred file
  $devpbxf_forums_hfbro=decrypt("g+mY+jFR6y6ik9IswX1/pQ==")
  $devpbxf_forums_hfbrw=decrypt("EKnkElGpa16oEiNXBEwN6A==")
    file { "/app/shared/xenforo_hfb/dbcred/db_hfboards.hockeysfuture.com.php":
         content => template('atomiconline/dev_db_hfboards.hockeysfuture.com.php'),
         }

}
