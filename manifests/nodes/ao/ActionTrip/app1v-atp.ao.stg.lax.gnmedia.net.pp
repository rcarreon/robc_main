node 'app1v-atp.ao.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="atomiconline"
        $site="actiontrip"
        $httpd="actiontripc6"        
        include subversion::client
        include common::app
        include php::atp
        include php::pecl_imagick
        include httpd
        httpd::virtual_host {"stg.actiontrip.com":}




        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_shared/atp-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_log/app1v-atp.ao.stg.lax.gnmedia.net",
        }

        common::nfsmount { "/app/ugc":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_shared/atp-ugc",
        }

    file { '/app/shared/stg.actiontrip.com':
        ensure => directory,
        owner  => deploy,
        group  => deploy,
        mode   => 0775,
    }

#### Create dbcred file
    file { ['/app/shared/stg.actiontrip.com/dbcred']:
         ensure => directory,
         owner   => deploy,
         group   => deploy,
         mode    => 755,
         require => Mount["/app/shared"],
         }

    $actiontripdevropw=decrypt("mo4r/qqgiooEqWBVGHJrPA==")
    $actiontripdevrwpw=decrypt("mo4r/qqgiooEqWBVGHJrPA==")
    $actiontripstgropw=decrypt("WXLItcPTq7+QzxF66tifqQ==")
    $actiontripstgrwpw=decrypt("ZophZ2jcm2BOfbtdWvGkFw==")
    $actiontripprdropw=decrypt("uQgxH5bvBfiskST/GVxy7A==")
    $actiontripprdrwpw=decrypt("uQgxH5bvBfiskST/GVxy7A==")
    file { "/app/shared/stg.actiontrip.com/dbcred/db_actiontrip.com.php":
         ensure => file,
         owner   => deploy,
         group   => deploy,
         mode    => 755,
         content => template('atomiconline/db_actiontrip.com.php'),
         }



}
