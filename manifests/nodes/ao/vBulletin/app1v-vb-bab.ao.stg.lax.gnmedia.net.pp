node 'app1v-vb-bab.ao.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $httpd="vb6c"
    $project="vb53u"

    include common::app
    include sysctl
    include security
    include git::client
    include mysqld56::client
    class { 'php::install': }

    httpd::virtual_host {"babyandbump.momtastic.com": monitor => false,}

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_shared/vb-bab-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_log/app1v-vb-bab.ao.stg.lax.gnmedia.net",
    }

    common::nfsmount { "/app/ugc":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_stg_app_ugc/vb-bab-ugc",
    }

    file { ['/app/shared/vb_bab',
            '/app/shared/vb_bab/dbcred',
            '/app/shared/vb_bab/releases']:
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
    $stg_vb_babro=decrypt('6b1JWWLSaz344QaoLgxHzg==')
    $stg_vb_babrw=decrypt('4HFCCxPgva+WRXYuOJb2TQ==')
    file { '/app/shared/vb_bab/dbcred/db_babyandbump.momtastic.com.php':
            ensure   => file,
            owner    => 'deploy',
            group    => 'deploy',
            mode     => '0644',
            content  => template('atomiconline/stg_db_vb_babyandbump.momtastic.com.php'),
    }

}
