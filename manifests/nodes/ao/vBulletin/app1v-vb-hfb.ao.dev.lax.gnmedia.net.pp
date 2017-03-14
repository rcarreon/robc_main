node 'app1v-vb-hfb.ao.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $httpd="vbc6"
    $project="vb53u"

    include common::app
    include sysctl
    include security
    include git::client
    include mysqld56::client
    class { 'php::install': }

    httpd::virtual_host {"hfboards.hockeysfuture.com": monitor => false,}

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_shared/vb-hfb-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_log/app1v-vb-hfb.ao.dev.lax.gnmedia.net",
    }

    common::nfsmount { "/app/ugc":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_dev_app_ugc/vb-hfb-ugc",
    }

    file { ['/app/shared/vb_hfb',
            '/app/shared/vb_hfb/dbcred',
            '/app/shared/vb_hfb/releases']:
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
    $dev_vb_hfbro=decrypt('fyX2aNCjFHNL1xtjVqqH6w==')
    $dev_vb_hfbrw=decrypt('SXjQD0HW+e45g82B+fGOyQ==')
    file { '/app/shared/vb_hfb/dbcred/db_hfboards.hockeysfuture.com.php':
            ensure   => file,
            owner    => 'deploy',
            group    => 'deploy',
            mode     => '0644',
            content  => template('atomiconline/dev_db_vb_hfboards.hockeysfuture.com.php'),
    }


}
