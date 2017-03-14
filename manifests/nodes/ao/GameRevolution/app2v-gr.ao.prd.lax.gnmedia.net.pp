node 'app2v-gr.ao.prd.lax.gnmedia.net' {
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
        include memcached
        include mysqld56::client
        include php::ao_gr

        httpd::virtual_host {"gamerevolution.com":}

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/gamerev-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app2v-gr.ao.prd.lax.gnmedia.net",
        }

        common::nfsmount { "/app/ugc":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/gr-ugc",
        }

    file { "/app/shared/docroots/gamerevolution.com/config":
        ensure => directory,
        owner  => "root",
        group  => "root",
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
