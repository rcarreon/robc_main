############################################################################
##### Inclusive tag that includes all app directives #######################
############################################################################

    class ao::uid2::devserver {
        include ao::uid2::dev_packages
        include ao::uid2::sites
        include ao::uid2::sitesugc
        include ao::uid2::appdirs
        include ao::uid2::apc_config
        include ao::uid2::setupscript
        include ao::uid2::mcsphinx
        include ao::uid2::api_cs_memcache
}


############################################################################
##### Packages to be installed on app servers ##############################
############################################################################

    class ao::uid2::dev_packages {
        include common::app
        include httpd
        include subversion::client
        include rubygems::compass
        include rubygems::susy
        include rubygems::livereload
        include util::vim
        include memcached
        include puppet_agent::uid
        include yum::ius
        include php::ius
        include php::ius::mcrypt
        include git::client

        class {"mysqld56": template=>"56-default-uid",sqlclass=>"unsupported"}
        sphinx::conf { 'sbx-mostcraved': reindex => false, }

        #### Yum Packages
        package {"ant": ensure => installed,}
        package {"gcc-c++": ensure => installed,}
        package {"ruby-devel": ensure => installed,}
        package {"ant-apache-regexp": ensure => installed,}
        package {  [
                   'php54-pecl-xdebug',
                   'php54-tidy',
                   ]:
                   ensure => installed,
                }
        package {"php-channel-phpunit": ensure => installed,}
        package {"php-phpunit-PHPUnit": ensure => installed,}


}


############################################################################
##### A shared list of vhosts to be called by app servers ##################
############################################################################

    class ao::uid2::sites {
    httpd::virtual_host  {'api.comingsoon.net':                       monitor => false                       }
    httpd::virtual_host  {"sbx.mostcraved.craveonline.com":           monitor => false,                      }
    httpd::virtual_host  {"forums.playstationlifestyle.net":          monitor => false,                      }
    httpd::virtual_host  {"forums.sherdog.com":                       monitor => false,                      }
    httpd::virtual_host  {"forums.afterellen.com":                    monitor => false,                      }
    httpd::virtual_host  {"sbx.sherdog.com":                          monitor => false,                      }
    httpd::virtual_host  {"hfboards.hockeysfuture.com":               monitor => false,                      }
    httpd::virtual_host  {"forums.wrestlezone.com":                   monitor => false,                      }
    httpd::pbuid_wpvhost {"hockeysfuture.com":                        expect => "false", needextra => "true",}
    httpd::pbuid_wpvhost {"pbwp.gnmedia.net":                         expect => "false",                     }
    httpd::pbuid_wpvhost {"afterellen.com":                           expect => "false",                     }
    httpd::pbuid_wpvhost {"base.evolvemediallc.com":                  expect => "false",                     }
    httpd::pbuid_wpvhost {"musicfeeds.com.au":                        expect => "false", needextra => "true",}
    httpd::pbuid_wpvhost {"cattime.com":                              expect => "false", needextra => "true",}
    httpd::pbuid_wpvhost {"dogtime.com":                              expect => "false", needextra => "true",}
    httpd::pbuid_wpvhost {"beautyriot.com":                           expect => "false", needextra => "true",}
    httpd::pbuid_wpvhost {"evolvemediallc.com":                       expect => "false",                     }
    httpd::pbuid_wpvhost {"realitytea.com":                           expect => "false", needextra => "true",}
    httpd::pbuid_wpvhost {"playstationlifestyle.net":                 expect => "false", needextra => "true",}
    httpd::pbuid_wpvhost {"craveonline.com":                          expect => "false", needextra => "true",}
    httpd::pbuid_wpvhost {"craveonline.ca":                           expect => "false",                     }
    httpd::pbuid_wpvhost {"craveonline.com.au":                       expect => "false",                     }
    httpd::pbuid_wpvhost {"craveonline.co.uk":                        expect => "false",                     }
    httpd::pbuid_wpvhost {"craveonlinemedia.com":                     expect => "false",                     }
    httpd::pbuid_wpvhost {"heymanhustle.craveonline.com":             expect => "false", needextra => "true",}
    httpd::pbuid_wpvhost {"bufferzone.craveonline.com":               expect => "false", needextra => "true",}
    httpd::pbuid_wpvhost {"idontlikeyouinthatway.com":                expect => "false", needextra => "true",}
    httpd::pbuid_wpvhost {"idly.craveonline.com":                     expect => "false", needextra => "true",}
    httpd::pbuid_wpvhost {"hoopsvibe.com":                            expect => "false", needextra => "true",}
    httpd::pbuid_wpvhost {"thefashionspot.com":                       expect => "false", needextra => "true",}
    httpd::pbuid_wpvhost {"thefashionspot.ca":                        expect => "false",                     }
    httpd::pbuid_wpvhost {"thefashionspot.com.au":                    expect => "false",                     }
    httpd::pbuid_wpvhost {"theukfashionspot.co.uk":                   expect => "false",                     }
    httpd::pbuid_wpvhost {"totallyher.com":                           expect => "false",                     }
    httpd::pbuid_wpvhost {"totallyhermedia.com":                      expect => "false", needextra => "true",}
    httpd::pbuid_wpvhost {"totallykidz.com":                          expect => "false",                     }
    httpd::pbuid_wpvhost {"mumtasticuk.co.uk":                        expect => "false",                     }
    httpd::pbuid_wpvhost {"momtastic.com.au":                         expect => "false",                     }
    httpd::pbuid_wpvhost {"wholesomebabyfood.momtastic.com":          expect => "false", needextra => "true",}
    httpd::pbuid_wpvhost {"webecoist.momtastic.com":                  expect => "false",                     }
    httpd::pbuid_wpvhost {"momtastic.com":                            expect => "false",                     }
    httpd::pbuid_wpvhost {"ropeofsilicon.com":                        expect => "false",                     }
    httpd::pbuid_wpvhost {"studio.musicfeeds.com.au":                 expect => "false",                     }
    httpd::pbuid_wpvhost {"liveoutdoors.com":                         expect => "false", needextra => "true",}
    httpd::pbuid_wpvhost {"home.springboardplatform.com":             expect => "false", needextra => "true",}
    httpd::pbuid_wpvhost {"comingsoon.net":                           expect => "false",                     }
    httpd::pbuid_wpvhost {"wrestlezone.com":                          expect => "false", needextra => "true",}
    httpd::pbuid_wpvhost {"shocktillyoudrop.com":                     expect => "false", needextra => "true",}
    httpd::pbuid_wpvhost {"spidermanhype.com":                        expect => "false", needextra => "true",}
    httpd::pbuid_wpvhost {"superherohype.com":                        expect => "false", needextra => "true",}
    httpd::pbuid_wpvhost {"ringtv.craveonline.com":                   expect => "false", needextra => "true",}
    httpd::pbuid_wpvhost {"awards.totalbeauty.com":                   expect => "false", needextra => "true",}
    httpd::pbuid_wpvhost {"mandatory.com":                            expect => "false",                     }
    httpd::pbuid_wp_beta_vhost {"hockeysfuture.com":                  expect => "false",                     }
    httpd::pbuid_wp_beta_vhost {"pbwp.gnmedia.net":                   expect => "false",                     }
    httpd::pbuid_wp_beta_vhost {"afterellen.com":                     expect => "false",                     }
    httpd::pbuid_wp_beta_vhost {"base.evolvemediallc.com":            expect => "false",                     }
    httpd::pbuid_wp_beta_vhost {"musicfeeds.com.au":                  expect => "false", needextra => "true",}
    httpd::pbuid_wp_beta_vhost {"cattime.com":                        expect => "false",                     }
    httpd::pbuid_wp_beta_vhost {"dogtime.com":                        expect => "false",                     }
    httpd::pbuid_wp_beta_vhost {"beautyriot.com":                     expect => "false",                     }
    httpd::pbuid_wp_beta_vhost {"evolvemediallc.com":                 expect => "false",                     }
    httpd::pbuid_wp_beta_vhost {"realitytea.com":                     expect => "false", needextra => "true",}
    httpd::pbuid_wp_beta_vhost {"playstationlifestyle.net":           expect => "false", needextra => "true",}
    httpd::pbuid_wp_beta_vhost {"craveonline.com":                    expect => "false", needextra => "true",}
    httpd::pbuid_wp_beta_vhost {"craveonline.ca":                     expect => "false",                     }
    httpd::pbuid_wp_beta_vhost {"craveonline.com.au":                 expect => "false",                     }
    httpd::pbuid_wp_beta_vhost {"craveonline.co.uk":                  expect => "false",                     }
    httpd::pbuid_wp_beta_vhost {"craveonlinemedia.com":               expect => "false",                     }
    httpd::pbuid_wp_beta_vhost {"bufferzone.craveonline.com":         expect => "false", needextra => "true",}
    httpd::pbuid_wp_beta_vhost {"thefashionspot.com":                 expect => "false", needextra => "true",}
    httpd::pbuid_wp_beta_vhost {"thefashionspot.ca":                  expect => "false",                     }
    httpd::pbuid_wp_beta_vhost {"thefashionspot.com.au":              expect => "false",                     }
    httpd::pbuid_wp_beta_vhost {"theukfashionspot.co.uk":             expect => "false",                     }
    httpd::pbuid_wp_beta_vhost {"hoopsvibe.com":                      expect => "false", needextra => "true",}
    httpd::pbuid_wp_beta_vhost {"totallyher.com":                     expect => "false", needextra => "true",}
    httpd::pbuid_wp_beta_vhost {"totallyhermedia.com":                expect => "false",                     }
    httpd::pbuid_wp_beta_vhost {"wholesomebabyfood.momtastic.com":    expect => "false", needextra => "true",}
    httpd::pbuid_wp_beta_vhost {"webecoist.momtastic.com":            expect => "false",                     }
    httpd::pbuid_wp_beta_vhost {"momtastic.com":                      expect => "false",                     }
    httpd::pbuid_wp_beta_vhost {"home.springboardplatform.com":       expect => "false", needextra => "true",}
    httpd::pbuid_wp_beta_vhost {"idly.craveonline.com":               expect => "false", needextra => "true",}
    httpd::pbuid_wp_beta_vhost {"wrestlezone.com":                    expect => "false", needextra => "true",}
    httpd::pbuid_wp_beta_vhost {"liveoutdoors.com":                   expect => "false", needextra => "true",}
    httpd::pbuid_wp_beta_vhost {"mumtasticuk.co.uk":                  expect => "false",                     }
    httpd::pbuid_wp_beta_vhost {"momtastic.com.au":                   expect => "false",                     }
    httpd::pbuid_wp_beta_vhost {"shocktillyoudrop.com":               expect => "false", needextra => "true",}
    httpd::pbuid_wp_beta_vhost {"superherohype.com":                  expect => "false", needextra => "true",}
    httpd::pbuid_wp_beta_vhost {"ringtv.craveonline.com":             expect => "false", needextra => "true",}
    httpd::pbuid_wp_beta_vhost {"comingsoon.net":                     expect => "false",                     }
    httpd::pbuid_wp_beta_vhost {"ropeofsilicon.com":                  expect => "false",                     }
    httpd::pbuid_wp_beta_vhost {"studio.musicfeeds.com.au":           expect => "false",                     }
    httpd::pbuid_wp_beta_vhost {"awards.totalbeauty.com":             expect => "false",                     }
    httpd::pbuid_wp_beta_vhost {"mandatory.com":                      expect => "false",                     }

}


############################################################################
##### Set up the app server directory structure to support Cap deploys #####
############################################################################

    class ao::uid2::appdirs {

        file { ['/app/shared/wordpress',
                '/app/shared/wordpress/dbcred',
                '/app/shared/wordpress/releases',
                '/app/shared/wordpress/current']:
                    ensure => directory,
                    owner => "$username",
                    group => "$username",
                    ignore => ".svn",
        }

        file { ['/app/shared/wordpress_beta',
                '/app/shared/wordpress_beta/dbcred',
                '/app/shared/wordpress_beta/releases',
                '/app/shared/wordpress_beta/current']:
                    ensure => directory,
                    owner => "$username",
                    group => "$username",
                    ignore => ".svn",
        }

        file { ['/app/shared/mostcraved',
                '/app/shared/mostcraved/dbcred',
                '/app/shared/mostcraved/releases',
                '/app/shared/mostcraved/current']:
                    ensure => directory,
                    owner => "$username",
                    group => "$username",
                    ignore => ".svn",
        }

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

        file { ['/app/shared/vb_wrestlezone',
                '/app/shared/vb_wrestlezone/dbcred',
                '/app/shared/vb_wrestlezone/releases',
                '/app/shared/vb_wrestlezone/current']:
                    ensure => directory,
                    owner => "$username",
                    group => "$username",
                    ignore => ".svn",
        }

        file { ['/app/shared/xenforo_psl',
                '/app/shared/xenforo_psl/dbcred',
                '/app/shared/xenforo_psl/releases',
                '/app/shared/xenforo_psl/current']:
                    ensure => directory,
                    owner => "$username",
                    group => "$username",
                    ignore => ".svn",
        }

        file { ['/app/shared/xenforo_sdc',
                '/app/shared/xenforo_sdc/dbcred',
                '/app/shared/xenforo_sdc/releases',
                '/app/shared/xenforo_sdc/current']:
                    ensure => directory,
                    owner => "$username",
                    group => "$username",
                    ignore => ".svn",
        }

        file { ['/app/shared/xenforo_ae',
                '/app/shared/xenforo_ae/dbcred',
                '/app/shared/xenforo_ae/releases',
                '/app/shared/xenforo_ae/current']:
                    ensure => directory,
                    owner => "$username",
                    group => "$username",
                    ignore => ".svn",
        }

        file { ['/app/shared/xenforo_hfb',
                '/app/shared/xenforo_hfb/dbcred',
                '/app/shared/xenforo_hfb/releases',
                '/app/shared/xenforo_hfb/current']:
                    ensure => directory,
                    owner => "$username",
                    group => "$username",
                    ignore => ".svn",
        }

        file { ['/app/shared/xenforo_wz',
                '/app/shared/xenforo_wz/dbcred',
                '/app/shared/xenforo_wz/releases',
                '/app/shared/xenforo_wz/current']:
                    ensure => directory,
                    owner => "$username",
                    group => "$username",
                    ignore => ".svn",
        }

        file { ['/app/shared/api_cs',
                '/app/shared/api_cs/dbcred',
                '/app/shared/api_cs/releases',
                '/app/shared/api_cs/current']:
                    ensure => directory,
                    owner => "$username",
                    group => "$username",
                    ignore => ".svn",
         }

        file { "/var/www/html": 
                    ensure => directory,
                    mode   => 755,
        }

        file {"/app/log/ruckus": 
                    ensure => directory,
                    owner => "$username",
                    group => "$username",
                    mode   => 777,
                    ignore => ".svn",
        }

        # create files to stop grants from being run
        file { "/var/lib/puppet/grants":
                    ensure => directory,
                    mode   => 755,
        }

        file { ['/var/lib/puppet/grants/mysqlGrant-collectd',
                '/var/lib/puppet/grants/mysqlGrant-dba.1',
                '/var/lib/puppet/grants/mysqlGrant-dba.240',
                '/var/lib/puppet/grants/mysqlGrant-dbtool',
                '/var/lib/puppet/grants/mysqlGrant-em_agent',
                '/var/lib/puppet/grants/mysqlGrant-em_agent-db',
                '/var/lib/puppet/grants/mysqlGrant-logrotate',
                '/var/lib/puppet/grants/mysqlGrant-nagiostpprd',
                '/var/lib/puppet/grants/mysqlGrant-nobody',
                '/var/lib/puppet/grants/mysqlGrant-root',
                '/var/lib/puppet/grants/mysqlGrant-toolshed',
                '/var/lib/puppet/grants/mysqlGrant-zmandaxworld',
                '/var/lib/puppet/grants/mysqlGrant-dba.12',
                '/var/lib/puppet/grants/mysqlGrant-dbtoolsdev',
                '/var/lib/puppet/grants/mysqlGrant-dbtoolsprd',
                '/var/lib/puppet/grants/mysqlGrant-zmanda']:
                    ensure => file,
                    owner => "root",
                    group => "root",
        }


}


############################################################################
##### Sphinx (MostCraved) ##################################################
############################################################################

    class ao::uid2::mcsphinx {

        cron { rebuild_index:
                    user    => sphinx,
                    ensure  => present,
                    hour  => 7,
                    minute  => 45,
                    command => "/usr/bin/indexer --config /etc/sphinx/sphinx.conf --all --rotate  > /tmp/mostcraved_reindex.log"
             }

}


############################################################################
##### Mount the UGC ########################################################
############################################################################

    class ao::uid2::sitesugc {
        common::ugcmount{ "/app/ugc":
            device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_shared/wp-ugc",
        }
        common::ugcmount{ "/app/ugcfpsl":
            device => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_dev_app_ugc/xf-ugc/forums.playstationlifestyle.net",
        }
        common::ugcmount{ "/app/ugcfsdc":
            device => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_dev_app_ugc/xf-ugc/forums.sherdog.com",
        }
        common::ugcmount{ "/app/ugcfae":
            device => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_dev_app_ugc/xf-ugc/forums.afterellen.com",
        }
        common::ugcmount{ "/app/ugcfhfb":
            device => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_dev_app_ugc/xf-ugc/hfboards.hockeysfuture.com",
        }
        common::ugcmount{ "/app/ugcfwz":
            device => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_dev_app_ugc/xf-ugc/forums.wrestlezone.com",
        }
        common::ugcmount{ "/app/ugcsdc":
            device => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_sbx_app_ugc/admin.sherdog.com_ugc",
        }
        common::nfsmount { '/app/ugcapics':
            device => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_dev_app_ugc/api-ugc/api.comingsoon.net",
        }    
}


############################################################################
##### APC Configuration for app servers ####################################
############################################################################
class ao::uid2::apc_config {

    #file {"/etc/php.d/apc.ini": 
    #     ensure => file,
    #     owner   => root,
    #     group   => root,
    #     mode    => 644,
    #     source  => "puppet:///modules/php/pbsbx_apc.ini",
    #     require => Package["php-pecl-apc"],
    #     }

}

############################################################################
##### Setup and SQL Grant scripts ##########################################
############################################################################

class ao::uid2::setupscript {

    file {"/usr/local/bin/sbx_setup.sh":
         ensure => file,
         mode    => 755,
         content => template('atomiconline/sbx_setup.sh'),
         }

    file {"/usr/local/bin/runcompass.sh":
         ensure => file,
         mode    => 755,
         content => template('atomiconline/sbx_runcompass.sh'),
         }

    file {"/usr/local/bin/runbetacompass.sh":
         ensure => file,
         mode    => 755,
         content => template('atomiconline/sbx_runbetacompass.sh'),
         }

    file {"/usr/local/bin/sbx_grants.sql":
         ensure => file,
         mode    => 644,
         content => template('atomiconline/sbx_grants.sql'),
         }

    file {"/usr/local/bin/sbx_hosthacks.sh":
         ensure => file,
         mode    => 755,
         content => template('atomiconline/sbx_hosthacks.sh'),
         }

    file {"/usr/local/bin/sbx_fixgems.sh":
         ensure => file,
         mode    => 755,
         content => template('atomiconline/sbx_fixgems.sh'),
         }

}


############################################################################
##### API_CS Memcache Settings #############################################
############################################################################

class ao::uid2::api_cs_memcache {

    file {"/app/shared/api_cs/dbcred/mem_api.comingsoon.net.php":
         ensure => file,
         content => template('atomiconline/uid_mem_api.comingsoon.net.php'),
         }
}


############################################################################
##### Pebblebed Wordpress Database Credentials for UIDS ####################
############################################################################

    class ao::uid2::pbwb_uid_dbcred {

        #### Set dbcred file default attributes
        File {
             ensure => file,
             }

        #### Create ruckus dbcred file
        $uidpbwpruckus=decrypt("QbiIrDRpJDdXmB+mWGduEQ==")
        file { "/app/shared/wordpress/dbcred/ruckus_database.inc.php":
             content => template('atomiconline/uid_ruckus_database.inc.php'),
             }

        #### Create beta ruckus dbcred file
        file { "/app/shared/wordpress_beta/dbcred/ruckus_database.inc.php":
             content => template('atomiconline/uid_ruckus_database.inc.php'),
             }

        #### Create mostcraved dbcred file
        $uidpbmostcravedw=decrypt("EJ0vbi7wCwyb+dXctA3FbQ==")
        file { "/app/shared/mostcraved/dbcred/db_mostcraved.php":
             content => template('atomiconline/uid_db_mostcraved.php'),
             }

        #### Create hockeysfuture.com dbcred file
        $uidpbwphockeysfuturero=decrypt("jo7udRasQ5vxhOPI17PoXQ==")
        $uidpbwphockeysfuturerw=decrypt("5HPa0kQCIZKmXJC5dV8w7w==")
        file { "/app/shared/wordpress/dbcred/db_hockeysfuture.com.php":
             content => template('atomiconline/uid_db_hockeysfuture.com.php'),
             }

        #### Create BETA hockeysfuture.com dbcred file
        $uidpbwpbetahockeysfuturero=decrypt("d6A7b+XkPWVEhJvw4iFjvg==")
        $uidpbwpbetahockeysfuturerw=decrypt("6InX+rLxSBYPsnCMS21PRA==")
        file { "/app/shared/wordpress_beta/dbcred/db_hockeysfuture.com.php":
             content => template('atomiconline/uid_db_beta_hockeysfuture.com.php'),
             }


        #### Create pbwp.gnmedia.net dbcred file
        $uidpbwpgnmediaro=decrypt("ZgfDUiOmwC5BIVjlTGIdWQ==")
        $uidpbwpgnmediarw=decrypt("4N56i4AwWPk08bgM/ZcVCg==")
        file { "/app/shared/wordpress/dbcred/db_pbwp.gnmedia.net.php":
             content => template('atomiconline/uid_db_pbwp.gnmedia.net.php'),
             }

        #### Create BETA pbwp.gnmedia.net dbcred file
        $uidpbwpbetagnmediaro=decrypt("T4rNgmZeqeN577/YjeV6Sw==")
        $uidpbwpbetagnmediarw=decrypt("Su4Ucfza364RCTxC6USlXA==")
        file { "/app/shared/wordpress_beta/dbcred/db_pbwp.gnmedia.net.php":
             content => template('atomiconline/uid_db_beta_pbwp.gnmedia.net.php'),
             }

        #### Create realitytea.com dbcred file
        $uidpbwprealitytearo=decrypt("hAMqRjPKgCE5SjUEYKB18w==")
        $uidpbwprealitytearw=decrypt("0iPc45U31NAD7qQ2UMZAYw==")
        file { "/app/shared/wordpress/dbcred/db_realitytea.com.php":
             content => template('atomiconline/uid_db_realitytea.com.php'),
             }

        #### Create BETA realitytea.com dbcred file
        $uidpbwpbetarealitytearo=decrypt("BmOJkcW2ZKv39Mp5gZksbA==")
        $uidpbwpbetarealitytearw=decrypt("VFA6FgIXYT7XajgKquRp6g==")
        file { "/app/shared/wordpress_beta/dbcred/db_realitytea.com.php":
             content => template('atomiconline/uid_db_beta_realitytea.com.php'),
             }

        #### Create craveonline.com dbcred file
        $uidpbwp_craveonlinero=decrypt("3oe8/fX89zFEag12sm5BlQ==")
        $uidpbwp_craveonlinerw=decrypt("1aEXgfV3d3ujJ+jWKg431w==")
        file { "/app/shared/wordpress/dbcred/db_craveonline.com.php":
             content => template('atomiconline/uid_db_craveonline.com.php'),
             }

        #### Create BETA craveonline.com dbcred file
        $uidpbwpbeta_craveonlinero=decrypt("uyvQHib+NSnssRnl4lmQgA==")
        $uidpbwpbeta_craveonlinerw=decrypt("3mEU3HH7lNTJ/I2ouSOsYg==")
        file { "/app/shared/wordpress_beta/dbcred/db_craveonline.com.php":
             content => template('atomiconline/uid_db_beta_craveonline.com.php'),
             }

        #### Create playstationlifestyle.net dbcred file
        $uidpbwpplaystationlifestylero=decrypt("hH5EESfXeClECjqJ1qnb7A==")
        $uidpbwpplaystationlifestylerw=decrypt("uPGnOiGi0cRn7koOaykVbA==")
        file { "/app/shared/wordpress/dbcred/db_playstationlifestyle.net.php":
             content => template('atomiconline/uid_db_playstationlifestyle.net.php'),
             }

        #### Create BETA playstationlifestyle.net dbcred file
        $uidpbwpbetaplaystationlifestylero=decrypt("Q82EobOGnsKqJZT633VnoA==")
        $uidpbwpbetaplaystationlifestylerw=decrypt("gMR3tLq0RhFJDpf4WxPkag==")
        file { "/app/shared/wordpress_beta/dbcred/db_playstationlifestyle.net.php":
             content => template('atomiconline/uid_db_beta_playstationlifestyle.net.php'),
             }

        #### Create idly.craveonline.com dbcred file
        $uidpbwp_idlyitwro=decrypt("gx5Wj/Ts1urwdGOHyZ3sqA==")
        $uidpbwp_idlyitwrw=decrypt("0kFFRfqq41CLngQBTqZiCA==")
        file { "/app/shared/wordpress/dbcred/db_idly.craveonline.com.php":
             content => template('atomiconline/uid_db_idly.craveonline.com.php'),
             }

        #### Create BETA idly.craveonline.com dbcred file
        $uidpbwpbeta_idlyitwro=decrypt("b9ddgMW20SwAe+MTAePC9Q==")
        $uidpbwpbeta_idlyitwrw=decrypt("D/cBI6gU6q3GK4s5TWRtNA==")
        file { "/app/shared/wordpress_beta/dbcred/db_idly.craveonline.com.php":
             content => template('atomiconline/uid_db_beta_idly.craveonline.com.php'),
             }

        #### Create thefashionspot.com dbcred file
        $uidpbwp_thefashionspotro=decrypt("YJllQNg386zf+s/Fheyxsg==")
        $uidpbwp_thefashionspotrw=decrypt("7QU7c8Q28nvWgSXEj8GBjg==")
        file { "/app/shared/wordpress/dbcred/db_thefashionspot.com.php":
             content => template('atomiconline/uid_db_thefashionspot.com.php'),
             }

        #### Create BETA thefashionspot.com dbcred file
        $uidpbwpbeta_thefashionspotro=decrypt("L9DpyGN7O6LG03xPXBxsrQ==")
        $uidpbwpbeta_thefashionspotrw=decrypt("ylbaDz2jeQEpHHswdrAa9Q==")
        file { "/app/shared/wordpress_beta/dbcred/db_thefashionspot.com.php":
             content => template('atomiconline/uid_db_beta_thefashionspot.com.php'),
             }

        #### Create api.comingsoon.net dbcred file
        $uid_api_csro=decrypt("X37rK2ftCRrP5Ol3JS21+g==")
        $uid_api_csrw=decrypt("XNpJjolob5TmNZRnBy3U2g==")
        file { "/app/shared/api_cs/dbcred/db_api.comingsoon.net.php":
             content => template('atomiconline/uid_db_api.comingsoon.net.php'),
             }      

        #### Create afterellen.com dbcred file
        $uidpbwp_afterellenro=decrypt("z+rVHXT4NSaONt8n9t2CVg==")
        $uidpbwp_afterellenrw=decrypt("rXFpimhCbkhzC40LNq/jqQ==")
        file { "/app/shared/wordpress/dbcred/db_afterellen.com.php":
             content => template('atomiconline/uid_db_afterellen.com.php'),
             }
 
        #### Create BETA afterellen.com dbcred file
        $uidpbwpbeta_afterellenro=decrypt("8W0EVWR6rQ+HRlNUH2Tq2w==")
        $uidpbwpbeta_afterellenrw=decrypt("ZGNe0Fq1u9u6pcT66S37iw==")
        file { "/app/shared/wordpress_beta/dbcred/db_afterellen.com.php":
             content => template('atomiconline/uid_db_beta_afterellen.com.php'),
             }
			 
        #### Create home.springboardplatform.com dbcred file
        $uidpbwp_springboardro=decrypt("815yqS5mh5eseLJlfvzn3A==")
        $uidpbwp_springboardrw=decrypt("7Ebtn6ouYd/as8CPEy4RhQ==")
        file { "/app/shared/wordpress/dbcred/db_home.springboardplatform.com.php":
             content => template('atomiconline/uid_db_home.springboardplatform.com.php'),
             }

        #### Create BETA home.springboardplatform.com dbcred file
        $uidpbwpbeta_springboardro=decrypt("DEp4t91zRFM85C4yFz1D7w==")
        $uidpbwpbeta_springboardrw=decrypt("ubb/YJo5ju+cD1dYo4RYiQ==")
        file { "/app/shared/wordpress_beta/dbcred/db_home.springboardplatform.com.php":
             content => template('atomiconline/uid_db_beta_home.springboardplatform.com.php'),
             }

         #### Create totallyhermedia.com dbcred file
         $uidpbwp_totallyhermediaro=decrypt("2V/hHTLLwm10xtKfLX/GNw==")
         $uidpbwp_totallyhermediarw=decrypt("ocBJVqZVHv1i9+6eNqNE+A==")
         file { "/app/shared/wordpress/dbcred/db_totallyhermedia.com.php":
              content => template('atomiconline/uid_db_totallyhermedia.com.php'),
              }

         #### Create BETA totallyhermedia.com dbcred file
         $uidpbwpbeta_totallyhermediaro=decrypt("GdwppSoSmPdrOH+X/CrRAg==")
         $uidpbwpbeta_totallyhermediarw=decrypt("fzajr3zqmdHKM55oRKgfgw==")
         file { "/app/shared/wordpress_beta/dbcred/db_totallyhermedia.com.php":
              content => template('atomiconline/uid_db_beta_totallyhermedia.com.php'),
              }

         #### Create craveonlinemedia.com dbcred file
         $uidpbwp_craveonlinemediaro=decrypt("AuDj1eX6BA8x4YXwMO3TeQ==")
         $uidpbwp_craveonlinemediarw=decrypt("iBOn+LjUJFXrI5rqacvmng==")
         file { "/app/shared/wordpress/dbcred/db_craveonlinemedia.com.php":
              content => template('atomiconline/uid_db_craveonlinemedia.com.php'),
              }

         #### Create BETA craveonlinemedia.com dbcred file
         $uidpbwpbeta_craveonlinemediaro=decrypt("9iX1lJIeJ4YHGJwFUkVMuw==")
         $uidpbwpbeta_craveonlinemediarw=decrypt("8Z+CQ/I7gqMjXL3hJjQ3GQ==")
         file { "/app/shared/wordpress_beta/dbcred/db_craveonlinemedia.com.php":
              content => template('atomiconline/uid_db_beta_craveonlinemedia.com.php'),
              }

         #### Create webecoist.momtastic.com dbcred file
         $uidpbwp_webecoistro=decrypt("RTrHElGCCx7diFz4UZSlFw==")
         $uidpbwp_webecoistrw=decrypt("lvQE5v/gMmgd4Xxd/0PLMg==")
         file { "/app/shared/wordpress/dbcred/db_webecoist.momtastic.com.php":
              content => template('atomiconline/uid_db_webecoist.momtastic.com.php'),
              }

         #### Create BETA webecoist.momtastic.com dbcred file
         $uidpbwpbeta_webecoistro=decrypt("E7Qptul8g5kkuh60UANwyQ==")
         $uidpbwpbeta_webecoistrw=decrypt("AYi62VzGAydyL9b0vcmNsw==")
         file { "/app/shared/wordpress_beta/dbcred/db_webecoist.momtastic.com.php":
              content => template('atomiconline/uid_db_beta_webecoist.momtastic.com.php'),
              }

         #### Create forums.playstationlifestyle.net dbcred file
         $uidpbxf_forums_pslro=decrypt("pEjrTdQs6WGMhCJONoTglw==")
         $uidpbxf_forums_pslrw=decrypt("qkUq0mUCKNL0xFf4QhyeSg==")
         file { "/app/shared/xenforo_psl/dbcred/db_forums.playstationlifestyle.net.php":
              content => template('atomiconline/uid_db_forums.playstationlifestyle.net.php'),
              }

         #### Create forums.sherdog.com dbcred file
         $uidpbxf_forums_sdcro=decrypt("bb50liIYY1LamsumEbHPQw==")
         $uidpbxf_forums_sdcrw=decrypt("Psw+ZrfMskg28Hqn/pn2rg==")
         file { "/app/shared/xenforo_sdc/dbcred/db_forums.sherdog.com.php":
              content => template('atomiconline/uid_db_forums.sherdog.com.php'),
              }

         #### Create forums.afterellen.com dbcred file
         $uidpbxf_forums_aero=decrypt("SAjO51WG2Aktgg7v6rb7WQ==")
         $uidpbxf_forums_aerw=decrypt("oRbp3+POqmiA/NVDuKwyYw==")
         file { "/app/shared/xenforo_ae/dbcred/db_forums.afterellen.com.php":
              content => template('atomiconline/uid_db_forums.afterellen.com.php'),
              }

         #### Create hfboards.hockeysfuture.com dbcred file
         $uidpbxf_forums_hfbro=decrypt("Md/b7HCusZwx/8vIyfexBg==")
         $uidpbxf_forums_hfbrw=decrypt("X/YR5JqjZ0QQ+2gfI/a7BA==")
         file { "/app/shared/xenforo_hfb/dbcred/db_hfboards.hockeysfuture.com.php":
              content => template('atomiconline/uid_db_hfboards.hockeysfuture.com.php'),
              }

         #### Create forums.wrestlezone.com dbcred file
         $uidpbxf_forums_wzro=decrypt("drrvRH5kZt9hffkLOKH7QQ==")
         $uidpbxf_forums_wzrw=decrypt("mnmM4bHuJBD5XIN9DZGAHw==")
         file { "/app/shared/xenforo_wz/dbcred/db_forums.wrestlezone.com.php":
              content => template('atomiconline/uid_db_forums.wrestlezone.com.php'),
              }

         #### Create comingsoon.net dbcred file
         $uidpbwp_comingsoonro=decrypt("sst/T5wtY0kQKJptnrx4QA==")
         $uidpbwp_comingsoonrw=decrypt("1JNQwWq/AeNZdg06JxikAA==")
         file { "/app/shared/wordpress/dbcred/db_comingsoon.net.php":
              content => template('atomiconline/uid_db_comingsoon.net.php'),
              }

        #### Create BETA comingsoon.net dbcred file
        $uidpbwpbeta_comingsoonro=decrypt("yMC3bkRXuKzdMn8X/MynJA==")
        $uidpbwpbeta_comingsoonrw=decrypt("KwA4blKlWN7X5etVUACZtg==")
        file { "/app/shared/wordpress_beta/dbcred/db_comingsoon.net.php":
             content => template('atomiconline/uid_db_beta_comingsoon.net.php'),
             }

        #### Create ringtv.craveonline.com dbcred file
        $uidpbwp_ringtvro=decrypt("SLSjStGBLDxOLZ98red4lQ==")
        $uidpbwp_ringtvrw=decrypt("Q3GOsxeR58qc5HgQ503Hng==")
        file { "/app/shared/wordpress/dbcred/db_ringtv.craveonline.com.php":
             content => template('atomiconline/uid_db_ringtv.craveonline.com.php'),
             }

        #### Create BETA ringtv.craveonline.com dbcred file
        $uidpbwpbeta_ringtvro=decrypt("z2mGuvIgH4ndJyjmYdI2Dw==")
        $uidpbwpbeta_ringtvrw=decrypt("DontpX4Vsk1A2nlkhIOerg==")
        file { "/app/shared/wordpress_beta/dbcred/db_ringtv.craveonline.com.php":
             content => template('atomiconline/uid_db_beta_ringtv.craveonline.com.php'),
             }

        #### Create superherohype.com dbcred file
        $uidpbwp_superherohypero=decrypt("xf5+rDCFU+JbOq07vyffow==")
        $uidpbwp_superherohyperw=decrypt("fY1I6t0QCVYK8qxekBsyCA==")
        file { "/app/shared/wordpress/dbcred/db_superherohype.com.php":
             content => template('atomiconline/uid_db_superherohype.com.php'),
             }

        #### Create BETA superherohype.com dbcred file
        $uidpbwpbeta_superherohypero=decrypt("uUBp8KhdG06J0qdzmED/cA==")
        $uidpbwpbeta_superherohyperw=decrypt("qmuEv2ltHCGpLO1lwSj4mA==")
        file { "/app/shared/wordpress_beta/dbcred/db_superherohype.com.php":
             content => template('atomiconline/uid_db_beta_superherohype.com.php'),
             }

        #### Create shocktillyoudrop.com dbcred file
        $uidpbwp_shocktillyoudropro=decrypt("ujdq6rrYlnvNJT+niP9Yyw==")
        $uidpbwp_shocktillyoudroprw=decrypt("h0iLZjmv/7RoiLKM4keYEQ==")
        file { "/app/shared/wordpress/dbcred/db_shocktillyoudrop.com.php":
             content => template('atomiconline/uid_db_shocktillyoudrop.com.php'),
             }

        #### Create BETA shocktillyoudrop.com dbcred file
        $uidpbwpbeta_shocktillyoudropro=decrypt("bd+wt4T0T9me+e1qNqpmkQ==")
        $uidpbwpbeta_shocktillyoudroprw=decrypt("p7wBLlUntzLJ8fanKnbrjA==")
        file { "/app/shared/wordpress_beta/dbcred/db_shocktillyoudrop.com.php":
             content => template('atomiconline/uid_db_beta_shocktillyoudrop.com.php'),
             }

        #### Create momtastic.com dbcred file
        $uidpbwp_momtasticro=decrypt("NgAnS/3C5i/7iQfbF+CWyw==")
        $uidpbwp_momtasticrw=decrypt("3n5k8tmTJwopEboFuFSb9w==")
        file { "/app/shared/wordpress/dbcred/db_momtastic.com.php":
             content => template('atomiconline/uid_db_momtastic.com.php'),
             }

        #### Create BETA momtastic.com dbcred file
        $uidpbwpbeta_momtasticro=decrypt("ZJGbpP6XJCpXjE4mVcx27A==")
        $uidpbwpbeta_momtasticrw=decrypt("uThQp31qJrU/WM3Os1HPnA==")
        file { "/app/shared/wordpress_beta/dbcred/db_momtastic.com.php":
             content => template('atomiconline/uid_db_beta_momtastic.com.php'),
             }

        #### Create mumtasticuk.co.uk dbcred file
        $uidpbwp_mumtasticukro=decrypt("NrBdaMr8UJRpnqJ1ZbYtrQ==")
        $uidpbwp_mumtasticukrw=decrypt("gAo4xJlm5WnO2pWEcTVYVQ==")
        file { "/app/shared/wordpress/dbcred/db_mumtasticuk.co.uk.php":
             content => template('atomiconline/uid_db_mumtasticuk.co.uk.php'),
             }

        #### Create BETA mumtasticuk.co.uk dbcred file
        $uidpbwpbeta_mumtasticukro=decrypt("dFQkpOebNfm/nJHu4D35Ng==")
        $uidpbwpbeta_mumtasticukrw=decrypt("ejdmKJyLJ9WntMn7I1s9uA==")
        file { "/app/shared/wordpress_beta/dbcred/db_mumtasticuk.co.uk.php":
             content => template('atomiconline/uid_db_beta_mumtasticuk.co.uk.php'),
             }

        #### Create momtastic.com.au dbcred file
        $uidpbwp_momtasticauro=decrypt("vA5I8VQ+ecqlUFL3kKKtzA==")
        $uidpbwp_momtasticaurw=decrypt("JbJk9biMvkxF+Nlh+rQXiQ==")
        file { "/app/shared/wordpress/dbcred/db_momtastic.com.au.php":
             content => template('atomiconline/uid_db_momtastic.com.au.php'),
             }

        #### Create BETA momtastic.com.au dbcred file
        $uidpbwpbeta_momtasticauro=decrypt("h0u8Bhp0CK3EbOLNbFa+ag==")
        $uidpbwpbeta_momtasticaurw=decrypt("pgBSRCgtD3uBsuMQjyHWAA==")
        file { "/app/shared/wordpress_beta/dbcred/db_momtastic.com.au.php":
             content => template('atomiconline/uid_db_beta_momtastic.com.au.php'),
             }

        #### Create wrestlezone.com dbcred file
        $uidpbwp_wrestlezonero=decrypt("LdirWUzXvIza1zYn9PXRQQ==")
        $uidpbwp_wrestlezonerw=decrypt("kTBDi67/CK2C3MvZPgMnig==")
        file { "/app/shared/wordpress/dbcred/db_wrestlezone.com.php":
             content => template('atomiconline/uid_db_wrestlezone.com.php'),
             }

        #### Create BETA wrestlezone.com dbcred file
        $uidpbwpbeta_wrestlezonero=decrypt("zH5Ie4/yEHD9TfWDI2/yyg==")
        $uidpbwpbeta_wrestlezonerw=decrypt("8PXzTO2xxgKitZgwSwfd7w==")
        file { "/app/shared/wordpress_beta/dbcred/db_wrestlezone.com.php":
             content => template('atomiconline/uid_db_beta_wrestlezone.com.php'),
             }

        #### Create liveoutdoors.com dbcred file
        $uidpbwp_liveoutdoorsro=decrypt("2m0iVCjtRXGwmNYPAYrnsA==")
        $uidpbwp_liveoutdoorsrw=decrypt("maW6B8R81B+GkljVdIpaFQ==")
        file { "/app/shared/wordpress/dbcred/db_liveoutdoors.com.php":
             content => template('atomiconline/uid_db_liveoutdoors.com.php'),
             }

        #### Create BETA liveoutdoors.com dbcred file
        $uidpbwpbeta_liveoutdoorsro=decrypt("FOJTNEOJqu4UbCC2VNGcfw==")
        $uidpbwpbeta_liveoutdoorsrw=decrypt("GFc/pycNL8aLWJfo8GE8SQ==")
        file { "/app/shared/wordpress_beta/dbcred/db_liveoutdoors.com.php":
             content => template('atomiconline/uid_db_beta_liveoutdoors.com.php'),
             }

        #### Create hoopsvibe.com dbcred file
        $uidpbwp_hoopsvibero=decrypt("w9u1msOhHtHy5z0If8/W3w==")
        $uidpbwp_hoopsviberw=decrypt("M6edA/UebjeubuGg/Fiw2g==")
        file { "/app/shared/wordpress/dbcred/db_hoopsvibe.com.php":
             content => template('atomiconline/uid_db_hoopsvibe.com.php'),
             }

        #### Create BETA hoopsvibe.com dbcred file
        $uidpbwpbeta_hoopsvibero=decrypt("o5NdIz0pY4adCrZs7ZEpQA==")
        $uidpbwpbeta_hoopsviberw=decrypt("elWraciE3sAjYDIKxShm9A==")
        file { "/app/shared/wordpress_beta/dbcred/db_hoopsvibe.com.php":
             content => template('atomiconline/uid_db_beta_hoopsvibe.com.php'),
             }

        #### Create wholesomebabyfood.momtastic.com dbcred file
        $uidpbwp_wholesomebabyfoodro=decrypt("CzBKg8v5T+LDwP1bCrv8Eg==")
        $uidpbwp_wholesomebabyfoodrw=decrypt("h87Tl4V/uWShHLHhQaYHqg==")
        file { "/app/shared/wordpress/dbcred/db_wholesomebabyfood.momtastic.com.php":
             content => template('atomiconline/uid_db_wholesomebabyfood.momtastic.com.php'),
             }

        #### Create BETA wholesomebabyfood.momtastic.com dbcred file
        $uidpbwpbeta_wholesomebabyfoodro=decrypt("IF6LW4ILYIwCqU2mYy3yKw==")
        $uidpbwpbeta_wholesomebabyfoodrw=decrypt("6Fx0A7HhrxcDSHWg2SHKnA==")
        file { "/app/shared/wordpress_beta/dbcred/db_wholesomebabyfood.momtastic.com.php":
             content => template('atomiconline/uid_db_beta_wholesomebabyfood.momtastic.com.php'),
             }

        #### Create totallyher.com dbcred file
        $uidpbwp_totallyherro=decrypt("C6xykREScIzuY2AQ3A013w==")
        $uidpbwp_totallyherrw=decrypt("4/Ud8ZjiOYJQ3KrJWq8fXQ==")
        file { "/app/shared/wordpress/dbcred/db_totallyher.com.php":
             content => template('atomiconline/uid_db_totallyher.com.php'),
             }

        #### Create BETA totallyher.com dbcred file
        $uidpbwpbeta_totallyherro=decrypt("EZD/3p+/W02aNwIzfRUvDQ==")
        $uidpbwpbeta_totallyherrw=decrypt("7rrSYrD1F31envzS/TUg4A==")
        file { "/app/shared/wordpress_beta/dbcred/db_totallyher.com.php":
             content => template('atomiconline/uid_db_beta_totallyher.com.php'),
             }

        #### Create bufferzone.craveonline.com dbcred file
        $uidpbwp_bufferzonero=decrypt("QoysLr27NQaunANkffjKCg==")
        $uidpbwp_bufferzonerw=decrypt("aM1sZdFFHI5YxJV5BZrSlw==")
        file { "/app/shared/wordpress/dbcred/db_bufferzone.craveonline.com.php":
             content => template('atomiconline/uid_db_bufferzone.craveonline.com.php'),
             }

        #### Create BETA bufferzone.craveonline.com dbcred file
        $uidpbwpbeta_bufferzonero=decrypt("lP7FELc8r/q31mMoXzxc1g==")
        $uidpbwpbeta_bufferzonerw=decrypt("y7V9ImSvX1TUCR4Y68e2SQ==")
        file { "/app/shared/wordpress_beta/dbcred/db_bufferzone.craveonline.com.php":
             content => template('atomiconline/uid_db_beta_bufferzone.craveonline.com.php'),
             }

        #### Create BETA mandatory.com dbcred file
        $uidpbwpbeta_mandatoryro=decrypt("8uOwxtPLKCjNgxVRtzRJpA==")
        $uidpbwpbeta_mandatoryrw=decrypt("GLA2VP9YjvAkjzSO6+ldaA==")
        file { "/app/shared/wordpress_beta/dbcred/db_mandatory.com.php":
             content => template('atomiconline/uid_db_beta_mandatory.com.php'),
             }

        #### Create mandatory.com dbcred file
        $uidpbwp_mandatoryro=decrypt("UZcAok2e7KylMetcZCbaXQ==")
        $uidpbwp_mandatoryrw=decrypt("8I+D4I25C3BWmYv+/eczcg==")
        file { "/app/shared/wordpress/dbcred/db_mandatory.com.php":
             content => template('atomiconline/uid_db_mandatory.com.php'),
             }



#sbxtoken

        #### Create awards.totalbeauty.com dbcred file
        $uidpbwp_awards_totalbeautyro=decrypt("RkSPINiVZukSNxLGaP0esw==")
        $uidpbwp_awards_totalbeautyrw=decrypt("eyGkh9qIDAiwMvrSV+IhCA==")
        file { "/app/shared/wordpress/dbcred/db_awards.totalbeauty.com.php":
             content => template('atomiconline/uid_db_awards.totalbeauty.com.php'),
             }


        #### Create BETA awards.totalbeauty.com dbcred file
        $uidpbwpbeta_awards_totalbeautyro=decrypt("DfD96jSXumABYBAy9+IdYw==")
        $uidpbwpbeta_awards_totalbeautyrw=decrypt("0uNZSg1nh3BGBObI8Gh7HA==")
        file { "/app/shared/wordpress_beta/dbcred/db_awards.totalbeauty.com.php":
             content => template('atomiconline/uid_db_beta_awards.totalbeauty.com.php'),
             }

        #### Create ropeofsilicon.com dbcred file
        $uidpbwp_ropeofsiliconro=decrypt("wXOofyW5rKp0TiErA7b1VA==")
        $uidpbwp_ropeofsiliconrw=decrypt("QWZpiC0f2qD9+rxpfihjaQ==")
        file { "/app/shared/wordpress/dbcred/db_ropeofsilicon.com.php":
             content => template('atomiconline/uid_db_ropeofsilicon.com.php'),
             }

        #### Create BETA ropeofsilicon.com dbcred file
        $uidpbwpbeta_ropeofsiliconro=decrypt("u8PKmhd22Tug5N0VMaPr/w==")
        $uidpbwpbeta_ropeofsiliconrw=decrypt("u5Pt8zWjPr0RuiktXo164A==")
        file { "/app/shared/wordpress_beta/dbcred/db_ropeofsilicon.com.php":
             content => template('atomiconline/uid_db_beta_ropeofsilicon.com.php'),
             }

        #### Create dogtime.com dbcred file
        $uidpbwp_dogtimero=decrypt("Ioog/pOV/pMPD5IEmeoEDQ==")
        $uidpbwp_dogtimerw=decrypt("XU6mgdObx7IoUI/cOLM7JA==")
        file { "/app/shared/wordpress/dbcred/db_dogtime.com.php":
             content => template('atomiconline/uid_db_dogtime.com.php'),
             }

        #### Create BETA dogtime.com dbcred file
        $uidpbwpbeta_dogtimero=decrypt("lNY9l9LgrKzFDMSxYpDBIA==")
        $uidpbwpbeta_dogtimerw=decrypt("TI0S3Luyl0hbsG7kmu8T/A==")
        file { "/app/shared/wordpress_beta/dbcred/db_dogtime.com.php":
             content => template('atomiconline/uid_db_beta_dogtime.com.php'),
             }

        #### Create base.evolvemediallc.com dbcred file
        $uidpbwp_basero=decrypt("7CZbme/DwK4dMb3NsH+cyA==")
        $uidpbwp_baserw=decrypt("S9aMjg33IP8RoToaK1rkRQ==")
        file { "/app/shared/wordpress/dbcred/db_base.evolvemediallc.com.php":
             content => template('atomiconline/uid_db_base.evolvemediallc.com.php'),
             }

        #### Create BETA base.evolvemediallc.com dbcred file
        $uidpbwpbeta_basero=decrypt("P5Vf7tpDJPbYwQ2HKIzafw==")
        $uidpbwpbeta_baserw=decrypt("3HxNNC39cXKGfH7q6pUayA==")
        file { "/app/shared/wordpress_beta/dbcred/db_base.evolvemediallc.com.php":
             content => template('atomiconline/uid_db_beta_base.evolvemediallc.com.php'),
             }

        #### Create musicfeeds.com.au dbcred file
        $uidpbwp_musicfeedsro=decrypt("7nFdEKdG8CrxdtEEK7GuoQ==")
        $uidpbwp_musicfeedsrw=decrypt("QKEeQ7OUWk1qxo6991qedA==")
        file { "/app/shared/wordpress/dbcred/db_musicfeeds.com.au.php":
             content => template('atomiconline/uid_db_musicfeeds.com.au.php'),
             }

        #### Create BETA musicfeeds.com.au dbcred file
        $uidpbwpbeta_musicfeedsro=decrypt("6d3K5WEOikJ0UqxVHqTEpQ==")
        $uidpbwpbeta_musicfeedsrw=decrypt("mfkjATUmKBBak3JSOBbq+A==")
        file { "/app/shared/wordpress_beta/dbcred/db_musicfeeds.com.au.php":
             content => template('atomiconline/uid_db_beta_musicfeeds.com.au.php'),
             }

        #### Create cattime.com dbcred file
        $uidpbwp_cattimero=decrypt("lph0FGZimQh1h8O7VGVwlg==")
        $uidpbwp_cattimerw=decrypt("5hghvEcC9jRynaVv36a7zA==")
        file { "/app/shared/wordpress/dbcred/db_cattime.com.php":
             content => template('atomiconline/uid_db_cattime.com.php'),
             }

        #### Create BETA cattime.com dbcred file
        $uidpbwpbeta_cattimero=decrypt("29hUArkdv8dhSKvJkM7w5w==")
        $uidpbwpbeta_cattimerw=decrypt("8N0E8erGJbEX0IKQqDbSvA==")
        file { "/app/shared/wordpress_beta/dbcred/db_cattime.com.php":
             content => template('atomiconline/uid_db_beta_cattime.com.php'),
             }

        #### Create beautyriot.com dbcred file
        $uidpbwp_beautyriotro=decrypt("/KFSbfpOo+Ku7Krvl/NhwQ==")
        $uidpbwp_beautyriotrw=decrypt("VEApgjNEUgv+tK+vykXbHw==")
        file { "/app/shared/wordpress/dbcred/db_beautyriot.com.php":
             content => template('atomiconline/uid_db_beautyriot.com.php'),
             }
  
        #### Create BETA beautyriot.com dbcred file
        $uidpbwpbeta_beautyriotro=decrypt("Js+HTq1HP00SSHOZ2NZvyQ==")
        $uidpbwpbeta_beautyriotrw=decrypt("cn1bDPEVFPymrNQ8xBKXEA==")
        file { "/app/shared/wordpress_beta/dbcred/db_beautyriot.com.php":
             content => template('atomiconline/uid_db_beta_beautyriot.com.php'),
             }

        #### Create evolvemediallc.com dbcred file
        $uidpbwp_evolvemediallcro=decrypt("9JYh1Z5MHStCFtghvP/6Og==")
        $uidpbwp_evolvemediallcrw=decrypt("FM/ctoCrJrvBcyccNuNCrw==")
        file { "/app/shared/wordpress/dbcred/db_evolvemediallc.com.php":
             content => template('atomiconline/uid_db_evolvemediallc.com.php'),
             }
  
        #### Create BETA evolvemediallc.com dbcred file
        $uidpbwpbeta_evolvemediallcro=decrypt("kodPJQj99WYMLmxlNmpZYQ==")
        $uidpbwpbeta_evolvemediallcrw=decrypt("5HQi7zxW8nhG6bs7KUBTqQ==")
        file { "/app/shared/wordpress_beta/dbcred/db_evolvemediallc.com.php":
             content => template('atomiconline/uid_db_beta_evolvemediallc.com.php'),
             }

        #### Create totallykidz.com dbcred file
        $uidpbwp_totallykidzro=decrypt("R9UtJ/T+nfl/6//ioeWPXQ==")
        $uidpbwp_totallykidzrw=decrypt("h6GNxf1od3gVc7hMs2smZQ==")
        file { "/app/shared/wordpress/dbcred/db_totallykidz.com.php":
             content => template('atomiconline/uid_db_totallykidz.com.php'),
             }

        #### Create BETA totallykidz.com dbcred file
        $uidpbwpbeta_totallykidzro=decrypt("tbXjSREsLWCBVHXhDrg6hw==")
        $uidpbwpbeta_totallykidzrw=decrypt("mES2lbl4ok8uvNLMeKzMkw==")
        file { "/app/shared/wordpress_beta/dbcred/db_totallykidz.com.php":
             content => template('atomiconline/uid_db_beta_totallykidz.com.php'),
             }

        #### Create BETA studio.musicfeeds.com.au dbcred file
        $uidpbwpbeta_studio_musicfeedsro=decrypt("Q+7Nfmo/KW+uQOr7lxP/hA==")
        $uidpbwpbeta_studio_musicfeedsrw=decrypt("iN7iRZSNhAKPnFxTT3WqJg==")
        file { "/app/shared/wordpress_beta/dbcred/db_studio.musicfeeds.com.au.php":
             content => template('atomiconline/uid_db_beta_studio.musicfeeds.com.au.php'),
             }

        #### Create studio.musicfeeds.com.au dbcred file
        $uidpbwp_studio_musicfeedsro=decrypt("XJfKuB0WhdclP9ZDuL51+Q==")
        $uidpbwp_studio_musicfeedsrw=decrypt("E0roRiwENjC0S+0grZU6Gw==")
        file { "/app/shared/wordpress/dbcred/db_studio.musicfeeds.com.au.php":
             content => template('atomiconline/uid_db_studio.musicfeeds.com.au.php'),
             }


}
