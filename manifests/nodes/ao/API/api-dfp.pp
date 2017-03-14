# Common packages and configs
class ao::api::dfp {

    # $project='api-dfp'
    # $httpd='api-dfp'
    include common::app
    include httpd
    include yum::ius
    include git::client
    include mysqld56::client

    
    file { ['/app/shared/api_dfp',
            '/app/shared/api_dfp/dbcred',
            '/app/shared/api_dfp/releases']:
                ensure => directory,
                owner  => 'deploy',
                group  => 'deploy',
                ignore => '.svn',
    }

    httpd::virtual_host {'api.dfp.gnmedia.net': monitor => false }
    
}



# DEV specific configs
class ao::api::dfp::dev_configs {

#### Set dev config file default attributes
    File {
        ensure   => file,
        owner    => 'deploy',
        group    => 'deploy',
        mode     => '0644',
    }

#### Create api.dfp.gnmedia.net dev dbcred file
    $dev_api_dfpro=decrypt('zhw94RJYw+hz8hRsbUlSfw==')
    $dev_api_dfprw=decrypt('HxLiqUuHUxQOPlNNWjLKyw==')
    file { '/app/shared/api_dfp/dbcred/db_api.dfp.gnmedia.net.php':
        content  => template('atomiconline/dev_db_api.dfp.gnmedia.net.php'),
    }

    file {'/app/shared/api_dfp/dbcred/mem_api.dfp.gnmedia.net.php':
        ensure   => file,
        content  => template('atomiconline/dev_mem_api.dfp.gnmedia.net.php'),
    }
}


# STG specific configs
class ao::api::dfp::stg_configs {

#### Set stg config file default attributes
    File {
        ensure => file,
        owner  => 'deploy',
        group  => 'deploy',
        mode   => '0644',
    }

#### Create api.comingsoon.net stg dbcred file
    $stg_api_dfpro=decrypt('1YI0WX7DVr+jFnYzm+/3yA==')
    $stg_api_dfprw=decrypt('zp6x/JMAlYADp2OUp3oPdg==')
    file { '/app/shared/api_dfp/dbcred/db_api.dfp.gnmedia.net.php':
                content => template('atomiconline/stg_db_api.dfp.gnmedia.net.php'),
    }

        file {'/app/shared/api_dfp/dbcred/mem_api.dfp.gnmedia.net.php':
        ensure  => file,
        content => template('atomiconline/stg_mem_api.dfp.gnmedia.net.php'),
    }
}



# PRD specific configs
class ao::api::dfp::prd_configs {

#### Set prd config file default attributes
    File {
        ensure => file,
        owner  => 'deploy',
        group  => 'deploy',
        mode   => '0644',
    } 

#### Create api.dfp.gnmedia.net prd dbcred file
    $prd_api_dfpro=decrypt('hXPG64Ez9YueswUIiuz+uA==')
    $prd_api_dfprw=decrypt('ghc5Ia8NvZ9J+2h5IX2EbQ==')
    file { '/app/shared/api_dfp/dbcred/db_api.dfp.gnmedia.net.php':
            content => template('atomiconline/prd_db_api.dfp.gnmedia.net.php'),
    }

    file {'/app/shared/api_dfp/dbcred/mem_api.dfp.gnmedia.net.php':
        ensure  => file,
        content => template('atomiconline/prd_mem_api.dfp.gnmedia.net.php'),
    }

}

