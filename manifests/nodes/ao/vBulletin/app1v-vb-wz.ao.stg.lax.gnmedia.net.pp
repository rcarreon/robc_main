node 'app1v-vb-wz.ao.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $httpd="vbc6"
    $project="vb"

    include common::app
    include git::client
    include php::wzf
    include mysqld56::client

    httpd::virtual_host { "forums.wrestlezone.com": monitor => false, }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_shared/vb-wz-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_log/app1v-vb-wz.ao.stg.lax.gnmedia.net",
    }

    common::nfsmount { "/app/ugc":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_stg_app_ugc/vb-wz-ugc",
    }

    file { ['/app/shared/vb_wz',
            '/app/shared/vb_wz/dbcred',
            '/app/shared/vb_wz/releases']:
            ensure   => directory,
            owner    => 'deploy',
            group    => 'deploy',
            ignore   => '.svn',
    }

    file { '/var/www/tmp':
            ensure   => directory,
            owner    => 'apache',
            group    => 'apache',
            mode     => '0755',
    }

    #### Create dbcred file
    $stg_vb_wzro=decrypt('kpgtPiVO4Zn9jcajt9SOGQ==')
    $stg_vb_wzrw=decrypt('UiX00wnuJmCeJrMZB/AZvw==')
    file { '/app/shared/vb_wz/dbcred/db_forums.wrestlezone.com.php':
            ensure   => file,
            owner    => 'deploy',
            group    => 'deploy',
            mode     => '0644',
            content  => template('atomiconline/stg_db_vb_forums.wrestlezone.com.php'),
    }

}
