node 'app1v-vb-tfs.ao.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $httpd="vbc6"
    $project="vb"
    $script_path="vb"

    include common::app
    include cronjob
    include php::tfs
    include git::client
    include mysqld56::client

    httpd::virtual_host { 'forums.thefashionspot.com': monitor => false}

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_shared/vb-tfs-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_log/app1v-vb-tfs.ao.dev.lax.gnmedia.net",
    }

    common::nfsmount { "/app/ugc":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_shared/vb-tfs-ugc",
    }

    file { "/etc/httpd/conf.d/forums.tfs.logins":
        source => "puppet:///modules/httpd/htpasswords/atomic-sites/forums.tfs.logins",
        owner   => "deploy",
        group   => "deploy",
    }

  #cronjob::do_cron_dot_d_cron_file {"tfs_vbseo_sitemap.cron": }

    file { ['/app/shared/vb_tfs',
            '/app/shared/vb_tfs/dbcred',
            '/app/shared/vb_tfs/releases']:
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
    $dev_vb_tfsro=decrypt('6LOvoKToNQ6ZlBb6x/2HOQ==')
    $dev_vb_tfsrw=decrypt('mUNFafd5ablcu35DQUVi8Q==')
    file { '/app/shared/vb_tfs/dbcred/db_forums.thefashionspot.com.php':
            ensure   => file,
            owner    => 'deploy',
            group    => 'deploy',
            mode     => '0644',
            content  => template('atomiconline/dev_db_vb_forums.thefashionspot.com.php'),
    }


}
