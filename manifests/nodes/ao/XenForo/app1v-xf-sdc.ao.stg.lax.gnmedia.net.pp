node 'app1v-xf-sdc.ao.stg.lax.gnmedia.net' {
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
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_shared/xf-sdc-shared",
    }

    common::nfsmount { "/app/log":
	    device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_stg_app_log/app1v-xf-sdc.ao.stg.lax.gnmedia.net",
    }

    common::nfsmount { '/app/ugcfsdc':
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_stg_app_ugc/xf-ugc/forums.sherdog.com",
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


#### Create forums.sherdog.com stg dbcred file
  $stgpbxf_forums_sdcro=decrypt("ygOzoRRskQ3IMjAWDl2xnA==")
  $stgpbxf_forums_sdcrw=decrypt("68ZY0GhsFnm+74lB84LIsQ==")
    file { "/app/shared/xenforo_sdc/dbcred/db_forums.sherdog.com.php":
         content => template('atomiconline/stg_db_forums.sherdog.com.php'),
         }


}
