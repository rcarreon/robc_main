# Common packages and configs
class ao::ep {

    include common::app
    include httpd
    include yum::ius
    include php::ius
    include php::ius::mcrypt
    include git::client
    include mysqld56::client

    file { ['/app/shared/ep',
            '/app/shared/ep/dashboard/dbcred',
            '/app/shared/ep/dashboard/releases']:
                ensure => directory,
                owner  => 'deploy',
                group  => 'deploy',
                ignore => '.git',
    }

    httpd::virtual_host {'evolveplatform.net': monitor => false }

}



# DEV specific configs
class ao::ep::dev_configs {

#### Set dev config file default attributes
    File {
        ensure   => file,
        owner    => 'deploy',
        group    => 'deploy',
        mode     => '0644',
    }

##### Create evolveplatform.net dev dbcred file
#    $dev_epro=decrypt('==')
#    $dev_eprw=decrypt('==')
#    file { '/app/shared/ep/dashboard/dbcred/db_evolveplatform.net.php':
#        content  => template('atomiconline/dev_db_evolveplatform.net.php'),
#    }
#
#    file {'/app/shared/ep/dashboard/dbcred/mem_evolveplatform.net.php':
#        ensure   => file,
#        content  => template('atomiconline/dev_mem_evolveplatform.net.php'),
#    }
}


# STG specific configs
class ao::ep::stg_configs {

#### Set stg config file default attributes
    File {
        ensure   => file,
        owner    => 'deploy',
        group    => 'deploy',
        mode     => '0644',
    }

##### Create evolveplatform.net stg dbcred file
#    $stg_epro=decrypt('==')
#    $stg_eprw=decrypt('==')
#    file { '/app/shared/ep/dashboard/dbcred/db_evolveplatform.net.php':
#        content  => template('atomiconline/stg_db_evolveplatform.net.php'),
#    }
#
#    file {'/app/shared/ep/dashboard/dbcred/mem_evolveplatform.net.php':
#        ensure   => file,
#        content  => template('atomiconline/stg_mem_evolveplatform.net.php'),
#    }
}



# PRD specific configs
class ao::ep::prd_configs {

#### Set prd config file default attributes
    File {
        ensure   => file,
        owner    => 'deploy',
        group    => 'deploy',
        mode     => '0644',
    }

##### Create evolveplatform.net prd dbcred file
#    $prd_epro=decrypt('==')
#    $prd_eprw=decrypt('==')
#    file { '/app/shared/ep/dashboard/dbcred/db_evolveplatform.net.php':
#        content => template('atomiconline/prd_db_evolveplatform.net.php'),
#    }
#
#    file {'/app/shared/ep/dashboard/dbcred/mem_evolveplatform.net.php':
#        ensure   => file,
#        content  => template('atomiconline/prd_mem_evolveplatform.net.php'),
#    }
}
