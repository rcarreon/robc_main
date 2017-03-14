node 'app1v-vb-shh.ao.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $httpd="vbc6"
    $project="vb"

    include common::app
    include httpd
    include php::shh
    include mysqld56::client
    include git::client 

    httpd::virtual_host {"forums.superherohype.com": monitor => false,}

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_shared/vb-shh-shared",
    }
    
    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_log/app1v-vb-shh.ao.dev.lax.gnmedia.net",
    }
    
    common::nfsmount { "/app/ugc":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_dev_app_ugc/vb-shh-ugc",
    }

    file { ['/app/shared/vb_shh',
            '/app/shared/vb_shh/dbcred',
            '/app/shared/vb_shh/releases']:
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
    $dev_vb_shhro=decrypt('XTY8xI4Wy/vOrQ6lrcUCKg==')
    $dev_vb_shhrw=decrypt('a9u2+FHXttd/To/p279z/Q==')
    file { '/app/shared/vb_shh/dbcred/db_forums.superherohype.com.php':
            ensure   => file,
            owner    => 'deploy',
            group    => 'deploy',
            mode     => '0644',
            content  => template('atomiconline/dev_db_vb_forums.superherohype.com.php'),
    }

}
