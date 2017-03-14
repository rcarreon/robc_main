node 'uid1v-dgrbavcic.ao.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="atomiconline"
        $site="actiontrip"
        $username="dgrbavcic"
        class {"mysqld56": template=>"dgrbavcic.ao.dev.lax-standalone"}

        include httpd
        include memcached
        include common::app
        include subversion::client
        include php
        include php::pecl_imagick
        include puppet_agent::uid
        include sphinx

        package { [ "php-devel", "php-pdo", "php-pear", "php-xmlrpc" ]:
                ensure => present,
        }


        common::nfsmount { "/sql/data":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_dgrbavcic_ao_dev_lax_sbx/sql/data",
        }

        common::nfsmount { "/sql/binlog":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_dgrbavcic_ao_dev_lax_sbx/sql/binlog",
        }

        common::nfsmount { "/sql/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_dgrbavcic_ao_dev_lax_sbx/sql/log",
        }

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_dgrbavcic_ao_dev_lax_sbx/appshared",
        }

        common::nfsmount { "/app/ugc":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_dgrbavcic_ao_dev_lax_sbx/appugc",
        }

        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_dgrbavcic_ao_dev_lax_sbx/applog",
        }


        ####################################################################################################
        ##### Sherdog ######################################################################################
        ####################################################################################################
        httpd::virtual_host {"sbx.sherdog.com": monitor => false,}

        file { ['/app/shared/sherdog',
                '/app/shared/sherdog/dbcred',
                '/app/shared/sherdog/docroots',
                '/app/shared/sherdog/docroots/sherdog.com']:
                    ensure => directory,
                    owner => "$username",
                    group => "$username",
                    ignore => ".svn",
             }

        file { ['/app/shared/sherdog_admin',
                '/app/shared/sherdog_admin/dbcred',
                '/app/shared/sherdog_admin/docroots',
                '/app/shared/sherdog_admin/docroots/admin.sherdog.com']:
                    ensure => directory,
                    owner => "$username",
                    group => "$username",
                    ignore => ".svn",
             }
        ####################################################################################################
        ##### End Sherdog ##################################################################################
        ####################################################################################################


}
