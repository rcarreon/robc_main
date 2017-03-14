# Common packages and configs
class ao::api::cs {

    # moved to node scope because this breaks in dyamic scoping
    # $project='api-cs'
    # $httpd='api-cs'
    include common::app
    include httpd
    include yum::ius
    include php::ius
    include php::ius::mcrypt
    include git::client
    include mysqld56::client

    file { ['/app/shared/api_cs',
            '/app/shared/api_cs/dbcred',
            '/app/shared/api_cs/releases']:
                ensure => directory,
                owner  => 'deploy',
                group  => 'deploy',
                ignore => '.svn',
    }

    httpd::virtual_host {'api.comingsoon.net': monitor => false }

}



# DEV specific configs
class ao::api::cs::dev_configs {

#### Set dev config file default attributes
    File {
        ensure   => file,
        owner    => 'deploy',
        group    => 'deploy',
        mode     => '0644',
    }

#### Create api.comingsoon.net dev dbcred file
    $dev_api_csro=decrypt('eeNdZVj3s3LLImzXsCpSzg==')
    $dev_api_csrw=decrypt('KPSHIvAx01I/R2IHOs5bew==')
    file { '/app/shared/api_cs/dbcred/db_api.comingsoon.net.php':
        content  => template('atomiconline/dev_db_api.comingsoon.net.php'),
    }

    file {'/app/shared/api_cs/dbcred/mem_api.comingsoon.net.php':
        ensure   => file,
        content  => template('atomiconline/dev_mem_api.comingsoon.net.php'),
    }
}


# STG specific configs
class ao::api::cs::stg_configs {

#### Set stg config file default attributes
    File {
        ensure   => file,
        owner    => 'deploy',
        group    => 'deploy',
        mode     => '0644',
    }

#### Create api.comingsoon.net stg dbcred file
    $stg_api_csro=decrypt('TyE2pB6+yoCAINRaUwmxTg==')
    $stg_api_csrw=decrypt('nFinr7wDdPUPfdUhaRy/oQ==')
    file { '/app/shared/api_cs/dbcred/db_api.comingsoon.net.php':
        content  => template('atomiconline/stg_db_api.comingsoon.net.php'),
    }

    file {'/app/shared/api_cs/dbcred/mem_api.comingsoon.net.php':
        ensure   => file,
        content  => template('atomiconline/stg_mem_api.comingsoon.net.php'),
    }
}



# PRD specific configs
class ao::api::cs::prd_configs {

#### Set prd config file default attributes
    File {
        ensure   => file,
        owner    => 'deploy',
        group    => 'deploy',
        mode     => '0644',
    }

#### Create api.comingsoon.net prd dbcred file
    $prd_api_csro=decrypt('jzMwXdwBlEgWOt+e/sbifg==')
    $prd_api_csrw=decrypt('nxUaqFR7dYbMj1nI9GVEEw==')
    file { '/app/shared/api_cs/dbcred/db_api.comingsoon.net.php':
        content => template('atomiconline/prd_db_api.comingsoon.net.php'),
    }

    file {'/app/shared/api_cs/dbcred/mem_api.comingsoon.net.php':
        ensure   => file,
        content  => template('atomiconline/prd_mem_api.comingsoon.net.php'),
    }
}
