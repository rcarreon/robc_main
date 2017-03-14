
node 'app1v-gr.ao.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="atomiconline"
        $site="gamerevolution"
        include memcached
        include common::app
        include subversion::client
        include httpd
        include mysqld56::client
        include php::ao_gr
        $grstgdbpass=decrypt("9lObWCAHPVNq/D2TtHVVZg==")

        httpd::virtual_host {"stg.gamerevolution.com":}

#        may need to add crons

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_shared/gr-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_log/app1v-gr.ao.stg.lax.gnmedia.net",
        }

        common::nfsmount { "/app/ugc":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_shared/gr-ugc",
        }

    file { "/app/shared/docroots/stg.gamerevolution.com/config":
        ensure => directory,
        owner  => "root",
        group  => "root",
    }

    file { "/app/shared/docroots/stg.gamerevolution.com/config/config.php":
         content => template('atomiconline/stg_db_gamerevolution.php'),
         owner  => "root",
         group  => "root",
         require => File["/app/shared/docroots/stg.gamerevolution.com/config"],
         }

    file { '/app/shared/docroots':
        ensure => directory,
        owner  => deploy,
        group  => deploy,
        mode   => 0755,
        require => File["/app/shared"],
    }

    file { '/app/shared/writable':
        ensure => directory,
        owner  => root,
        group  => root,
        mode   => 0755,
    }

    file { '/app/shared/writable/smarty':
        ensure => directory,
        owner  => apache,
        group  => apache,
        mode   => 0755,
        require => File["/app/shared/writable"],
    }

    file { '/app/shared/writable/smarty/web_c':
        ensure => directory,
        owner  => apache,
        group  => apache,
        mode   => 0755,
        require => File["/app/shared/writable/smarty"],
    }

}
