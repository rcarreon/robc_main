node 'app1v-build.ao.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="atomiconline"

    include php::ius
    include yum::ius
    include php::ius::mcrypt
    include git::client

    common::nfsmount { "/app/software":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_shared/ao-software-build",
    }

    common::nfsmount { "/app/storage":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_shared/api-cs-build-storage",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_log/app1v-build.ao.dev.lax.gnmedia.net",
    }


    file { ['/app/shared/api_cs',
            '/app/shared/api_cs/dbcred',
            '/app/shared/api_cs/releases']:
                ensure => directory,
                owner  => 'deploy',
                group  => 'deploy',
                ignore => '.svn',
    }

}
