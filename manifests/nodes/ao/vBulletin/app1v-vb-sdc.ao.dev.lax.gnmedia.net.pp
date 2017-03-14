node 'app1v-vb-sdc.ao.dev.lax.gnmedia.net' {
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

    httpd::virtual_host {"forums.sherdog.com": monitor => false,}


    file { "/etc/httpd/conf.d/sherdog.net.logins":
        source => "puppet:///modules/httpd/htpasswords/atomic-sites/sherdog.logins",
        owner  => "deploy",
        group  => "deploy",
    }

    file { "/etc/httpd/conf.d/forums.sherdog.com.logins":
        source => "puppet:///modules/httpd/htpasswords/atomic-sites/forums.sherdog.com.logins",
        owner  => "deploy",
        group  => "deploy",
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_shared/vb-sdc-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_log/app1v-vb-sdc.ao.dev.lax.gnmedia.net",
    }

    common::nfsmount { "/app/ugc":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_dev_app_ugc/vb-sdc-ugc",
    }

    file { ['/app/shared/vb_sdc',
            '/app/shared/vb_sdc/dbcred',
            '/app/shared/vb_sdc/releases']:
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
    $dev_vb_sdcro=decrypt('dZlYzSjgbA8mJxRtTw0DgA==')
    $dev_vb_sdcrw=decrypt('oL8x8KwWJcFq7IH4/OlSmw==')
    file { '/app/shared/vb_sdc/dbcred/db_forums.sherdog.com.php':
            ensure   => file,
            owner    => 'deploy',
            group    => 'deploy',
            mode     => '0644',
            content  => template('atomiconline/dev_db_vb_forums.sherdog.com.php'),
    }


}
