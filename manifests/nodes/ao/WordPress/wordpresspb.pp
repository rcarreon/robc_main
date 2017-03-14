############################################################################
##### Inclusive tag that includes all app directives #######################
############################################################################

class wordpresspb::appserver {

    # moved to node scope because this breaks in dyamic scoping
    # $project="atomiconline"
    # $httpd="pbwordpress"
    include wordpresspb::app_packages
    include wordpresspb::sites
    include wordpresspb::sitesugc
    include wordpresspb::appdirs
    include wordpresspb::apc_config

}


############################################################################
##### Packages to be installed on app servers ##############################
############################################################################

class wordpresspb::app_packages {

    include common::app
    include httpd
    include util::vim
    include mysqld56::client
    include subversion::client
    include rubygems::compass
    include rubygems::susy
    class { 'php::install': version => '5.6', ini_template => 'atomiconline/php.ini-pbwp.erb', extra_packages => ["php56u-mcrypt", "php56u-pecl-apcu", "php56u-soap"] }
                                                        
}                                                       
                                                        
                                                        
############################################################################
##### A shared list of vhosts to be called by app servers ##################
############################################################################

class wordpresspb::sites {
    include pipestash

    httpd::pbwordpress_vhost {"afterellen.com":                     expect => "6ac7804500c6bbac0d90a0fe8c68e7d8", needextra => "true",}
    httpd::pbwordpress_vhost {"base.evolvemediallc.com":            expect => "false",                                                }
    httpd::pbwordpress_vhost {"beautyriot.com":                     expect => "1cf554775f0077076d7b71e563042308", needextra => "true",}
    httpd::pbwordpress_vhost {"bufferzone.craveonline.com":         expect => "false",                            needextra => "true",}
    httpd::pbwordpress_vhost {"cattime.com":                        expect => "44e5bb901650ec61e9e0af1ff1bef5fe", needextra => "true",}
    httpd::pbwordpress_vhost {"dogtime.com":                        expect => "false",                            needextra => "true",}
    httpd::pbwordpress_vhost {"comingsoon.net":                     expect => "false",                            needextra => "true",}
    httpd::pbwordpress_vhost {"craveonline.ca":                     expect => "false",                                                }
    httpd::pbwordpress_vhost {"craveonline.com.au":                 expect => "false",                                                }
    httpd::pbwordpress_vhost {"craveonline.co.uk":                  expect => "false",                                                }
    httpd::pbwordpress_vhost {"craveonline.com":                    expect => "81f1107463d5e188739a27bccd18dab9", needextra => "true",}
    httpd::pbwordpress_vhost {"craveonlinemedia.com":               expect => "false",                                                }
    httpd::pbwordpress_vhost {"evolvemediallc.com":                 expect => "false",                                                }
    httpd::pbwordpress_vhost {"fashionspot.com":                    expect => "false",                            needextra => "true",}
    httpd::pbwordpress_vhost {"heymanhustle.craveonline.com":       expect => "false",                            needextra => "true",}
    httpd::pbwordpress_vhost {"hockeysfuture.com":                  expect => "bc2ae3134a3dd058ed8105843eaa87e4", needextra => "true",}
    httpd::pbwordpress_vhost {"hoopsvibe.com":                      expect => "false",                            needextra => "true",}
    httpd::pbwordpress_vhost {"home.springboardplatform.com":       expect => "false",                            needextra => "true",}
    httpd::pbwordpress_vhost {"idly.craveonline.com":               expect => "fc2df264294aaa0a8b854e856a84a2ec", needextra => "true",}
    httpd::pbwordpress_vhost {"idontlikeyouinthatway.com":          expect => "22d45bdc067561dba9c385ff3f5352c8", needextra => "true",}
    httpd::pbwordpress_vhost {"launch.gamerevolution.com":          expect => "false",                            needextra => "true",}
    httpd::pbwordpress_vhost {"liveoutdoors.com":                   expect => "68ec033d54c4f3b1ca4aca7f4c1e01ca", needextra => "true",}
    httpd::pbwordpress_vhost {"ca.momtastic.com":                   expect => "false",                                                }
    httpd::pbwordpress_vhost {"uk.momtastic.com":                   expect => "false",                                                }
    httpd::pbwordpress_vhost {"momtastic.com.au":                   expect => "false",                                                }
    httpd::pbwordpress_vhost {"momtastic.com":                      expect => "b24acb040fb2d2813c89008839b3fd6a", needextra => "true",}
    httpd::pbwordpress_vhost {"mumtastic.com.au":                   expect => "false",                            needextra => "true",}
    httpd::pbwordpress_vhost {"mumtasticuk.co.uk":                  expect => "false",                                                }
    httpd::pbwordpress_vhost {"au.momtastic.com":                   expect => "false",                            needextra => "true",}
    httpd::pbwordpress_vhost {"musicfeeds.com.au":                  expect => "false",                            needextra => "true",}
    httpd::pbwordpress_vhost {"pacman.craveonline.com":             expect => "false",                            needextra => "true",}
    httpd::pbwordpress_vhost {"pbwp.gnmedia.net":                   expect => "false",                                                }
    httpd::pbwordpress_vhost {"pebblebed.gnmedia.net":              expect => "false",                                                }
    httpd::pbwordpress_vhost {"playstationlifestyle.com":           expect => "false",                                                }
    httpd::pbwordpress_vhost {"playstationlifestyle.net":           expect => "e648000e5cd42cece065ea6b2f880692", needextra => "true",}
    httpd::pbwordpress_vhost {"realitytea.com":                     expect => "0f53d3d4577b5763f618949fdfd65ade", needextra => "true",}
    httpd::pbwordpress_vhost {"ringtv.craveonline.com":             expect => "a398b8f5636e1560c40bc8ebdad5c0a4", needextra => "true",}
    httpd::pbwordpress_vhost {"ropeofsilicon.com":                  expect => "false",                                                }
    httpd::pbwordpress_vhost {"ropesofsilicon.com":                 expect => "false",                                                }
    httpd::pbwordpress_vhost {"ropeofsilicone.com":                 expect => "false",                                                }
    httpd::pbwordpress_vhost {"shocktillyoudrop.com":               expect => "e60a8e9c71f6a281d7c3c4293e2a826f", needextra => "true",}
    httpd::pbwordpress_vhost {"shocktilyoudrop.com":                expect => "false",                                                }
    httpd::pbwordpress_vhost {"spidermanhype.com":                  expect => "false",                            needextra => "true",}
    httpd::pbwordpress_vhost {"superherohype.com":                  expect => "d254514d58fda348db17b12227af3867", needextra => "true",}
    httpd::pbwordpress_vhost {"thefashionspot.com":                 expect => "9269efc11618653b8a079a0ac376e69a", needextra => "true",}
    httpd::pbwordpress_vhost {"thefashionspot.ca":                  expect => "false",                                                }
    httpd::pbwordpress_vhost {"thefashionspot.com.au":              expect => "false",                                                }
    httpd::pbwordpress_vhost {"theukfashionspot.co.uk":             expect => "false",                                                }
    httpd::pbwordpress_vhost {"totallyher.com":                     expect => "0da17bb21a8d4e3e6438acab13dbc2ea", needextra => "true",}
    httpd::pbwordpress_vhost {"totallyhermedia.com":                expect => "false",                            needextra => "true",}
    httpd::pbwordpress_vhost {"totallykidz.com":                    expect => "6ec53628389f61ddedf7b25c663801fa",                     }
    httpd::pbwordpress_vhost {"webecoist.momtastic.com":            expect => "false",                                                }
    httpd::pbwordpress_vhost {"webecoist.com":                      expect => "false",                            needextra => "true",}
    httpd::pbwordpress_vhost {"wholesomebabyfood.momtastic.com":    expect => "false",                            needextra => "true",}
    httpd::pbwordpress_vhost {"wrestlezone.com":                    expect => "851cc24eadecaa7a82287c82808f23d0", needextra => "true",}
    httpd::pbwordpress_vhost {"studio.musicfeeds.com.au":           expect => "false",                                                }
    httpd::pbwordpress_vhost {"awards.totalbeauty.com":             expect => "false", needextra => "true",                           }
    httpd::pbwordpress_vhost {"mandatory.com":                      expect => "false",                                                }
}


############################################################################
##### Set up the app server directory structure to support Cap deploys #####
############################################################################

class wordpresspb::appdirs {

    File {
         ensure => directory,
         owner   => deploy,
         group   => deploy,
         mode    => 755,
         }

    file { ['/app/shared/wordpress', 
            '/app/shared/wordpress/dbcred', 
            '/app/shared/wordpress/releases']: 
            require => Mount["/app/shared"], 
         } 

    file { "/var/www/html": 
         ensure => directory,
         owner  => deploy,
         group  => deploy,
         mode   => 755,
         }

}


############################################################################
##### Set up the app UGC Directories #######################################
############################################################################

class wordpresspb::sitesugc {

    File {
         ensure => directory,
         owner   => apache,
         group   => apache,
         mode    => 755,
         require => Mount["/app/ugc"],
         }

    file { ['/app/ugc/hockeysfuture.com', 
            '/app/ugc/hockeysfuture.com/images', 
            '/app/ugc/hockeysfuture.com/assets', 
            '/app/ugc/hockeysfuture.com/assets/uploads', 
            '/app/ugc/hockeysfuture.com/assets/uploads/gallery']: }
    file { ['/app/ugc/pbwp.gnmedia.net', 
            '/app/ugc/pbwp.gnmedia.net/images', 
            '/app/ugc/pbwp.gnmedia.net/assets',
            '/app/ugc/pbwp.gnmedia.net/assets/uploads',
            '/app/ugc/pbwp.gnmedia.net/assets/uploads/gallery']: }
    file { ['/app/ugc/playstationlifestyle.net', 
            '/app/ugc/playstationlifestyle.net/images', 
            '/app/ugc/playstationlifestyle.net/assets',
            '/app/ugc/playstationlifestyle.net/assets/uploads',
            '/app/ugc/playstationlifestyle.net/assets/uploads/gallery']: }
    file { ['/app/ugc/craveonline.com', 
            '/app/ugc/craveonline.com/images', 
            '/app/ugc/craveonline.com/assets',
            '/app/ugc/craveonline.com/assets/uploads',
            '/app/ugc/craveonline.com/assets/uploads/gallery']: }
    file { ['/app/ugc/bufferzone.craveonline.com', 
            '/app/ugc/bufferzone.craveonline.com/images', 
            '/app/ugc/bufferzone.craveonline.com/assets',
            '/app/ugc/bufferzone.craveonline.com/assets/uploads',
            '/app/ugc/bufferzone.craveonline.com/assets/uploads/gallery']: }
    file { ['/app/ugc/idly.craveonline.com', 
            '/app/ugc/idly.craveonline.com/images', 
            '/app/ugc/idly.craveonline.com/assets',
            '/app/ugc/idly.craveonline.com/assets/uploads',
            '/app/ugc/idly.craveonline.com/assets/uploads/gallery']: }
    file { ['/app/ugc/thefashionspot.com', 
            '/app/ugc/thefashionspot.com/images', 
            '/app/ugc/thefashionspot.com/assets',
            '/app/ugc/thefashionspot.com/assets/uploads',
            '/app/ugc/thefashionspot.com/assets/uploads/gallery']: }
    file { ['/app/ugc/totallyher.com', 
            '/app/ugc/totallyher.com/images', 
            '/app/ugc/totallyher.com/assets',
            '/app/ugc/totallyher.com/assets/uploads',
            '/app/ugc/totallyher.com/assets/uploads/gallery']: }
    file { ['/app/ugc/totallykidz.com', 
            '/app/ugc/totallykidz.com/images', 
            '/app/ugc/totallykidz.com/assets',
            '/app/ugc/totallykidz.com/assets/uploads',
            '/app/ugc/totallykidz.com/assets/uploads/gallery']: }
    file { ['/app/ugc/wholesomebabyfood.momtastic.com', 
            '/app/ugc/wholesomebabyfood.momtastic.com/images', 
            '/app/ugc/wholesomebabyfood.momtastic.com/assets',
            '/app/ugc/wholesomebabyfood.momtastic.com/assets/uploads',
            '/app/ugc/wholesomebabyfood.momtastic.com/assets/uploads/gallery']: }
    file { ['/app/ugc/momtastic.com', 
            '/app/ugc/momtastic.com/images', 
            '/app/ugc/momtastic.com/assets',
            '/app/ugc/momtastic.com/assets/uploads',
            '/app/ugc/momtastic.com/assets/uploads/gallery']: }
    file { ['/app/ugc/hoopsvibe.com',
            '/app/ugc/hoopsvibe.com/images',
            '/app/ugc/hoopsvibe.com/assets',
            '/app/ugc/hoopsvibe.com/assets/uploads',
            '/app/ugc/hoopsvibe.com/assets/uploads/gallery']: }
    file { ['/app/ugc/liveoutdoors.com',
            '/app/ugc/liveoutdoors.com/images',
            '/app/ugc/liveoutdoors.com/assets',
            '/app/ugc/liveoutdoors.com/assets/uploads',
            '/app/ugc/liveoutdoors.com/assets/uploads/gallery']: }
    file { ['/app/ugc/wrestlezone.com',
            '/app/ugc/wrestlezone.com/images',
            '/app/ugc/wrestlezone.com/assets',
            '/app/ugc/wrestlezone.com/assets/uploads',
            '/app/ugc/wrestlezone.com/assets/uploads/gallery']: }
    file { ['/app/ugc/mumtasticuk.co.uk',
            '/app/ugc/mumtasticuk.co.uk/images',
            '/app/ugc/mumtasticuk.co.uk/assets',
            '/app/ugc/mumtasticuk.co.uk/assets/uploads',
            '/app/ugc/mumtasticuk.co.uk/assets/uploads/gallery']: }
    file { ['/app/ugc/momtastic.com.au',
            '/app/ugc/momtastic.com.au/images',
            '/app/ugc/momtastic.com.au/assets',
            '/app/ugc/momtastic.com.au/assets/uploads',
            '/app/ugc/momtastic.com.au/assets/uploads/gallery']: }
    file { ['/app/ugc/shocktillyoudrop.com',
            '/app/ugc/shocktillyoudrop.com/images',
            '/app/ugc/shocktillyoudrop.com/assets',
            '/app/ugc/shocktillyoudrop.com/assets/uploads',
            '/app/ugc/shocktillyoudrop.com/assets/uploads/gallery']: }
    file { ['/app/ugc/superherohype.com',
            '/app/ugc/superherohype.com/images',
            '/app/ugc/superherohype.com/assets',
            '/app/ugc/superherohype.com/assets/uploads',
            '/app/ugc/superherohype.com/assets/uploads/gallery']: }
    file { ['/app/ugc/ringtv.craveonline.com',
            '/app/ugc/ringtv.craveonline.com/images',
            '/app/ugc/ringtv.craveonline.com/assets',
            '/app/ugc/ringtv.craveonline.com/assets/uploads',
            '/app/ugc/ringtv.craveonline.com/assets/uploads/gallery']: }
    file { ['/app/ugc/comingsoon.net',
            '/app/ugc/comingsoon.net/images',
            '/app/ugc/comingsoon.net/assets',
            '/app/ugc/comingsoon.net/assets/uploads',
            '/app/ugc/comingsoon.net/assets/uploads/gallery']: }
    file { ['/app/ugc/webecoist.momtastic.com',
            '/app/ugc/webecoist.momtastic.com/images',
            '/app/ugc/webecoist.momtastic.com/assets',
            '/app/ugc/webecoist.momtastic.com/assets/uploads',
            '/app/ugc/webecoist.momtastic.com/assets/uploads/gallery']: }
    file { ['/app/ugc/totallyhermedia.com',
            '/app/ugc/totallyhermedia.com/images',
            '/app/ugc/totallyhermedia.com/assets',
            '/app/ugc/totallyhermedia.com/assets/uploads',
            '/app/ugc/totallyhermedia.com/assets/uploads/gallery']: }
    file { ['/app/ugc/craveonlinemedia.com',
            '/app/ugc/craveonlinemedia.com/images',
            '/app/ugc/craveonlinemedia.com/assets',
            '/app/ugc/craveonlinemedia.com/assets/uploads',
            '/app/ugc/craveonlinemedia.com/assets/uploads/gallery']: }
    file { ['/app/ugc/afterellen.com',
            '/app/ugc/afterellen.com/images',
            '/app/ugc/afterellen.com/assets',
            '/app/ugc/afterellen.com/assets/uploads',
            '/app/ugc/afterellen.com/assets/uploads/gallery']: }
    file { ['/app/ugc/base.evolvemediallc.com',
            '/app/ugc/base.evolvemediallc.com/images',
            '/app/ugc/base.evolvemediallc.com/assets',
            '/app/ugc/base.evolvemediallc.com/assets/uploads',
            '/app/ugc/base.evolvemediallc.com/assets/uploads/gallery']: }
    file { ['/app/ugc/musicfeeds.com.au',
            '/app/ugc/musicfeeds.com.au/images',
            '/app/ugc/musicfeeds.com.au/assets',
            '/app/ugc/musicfeeds.com.au/assets/uploads',
            '/app/ugc/musicfeeds.com.au/assets/uploads/gallery']: }
    file { ['/app/ugc/cattime.com',
            '/app/ugc/cattime.com/images',
            '/app/ugc/cattime.com/assets',
            '/app/ugc/cattime.com/assets/uploads',
            '/app/ugc/cattime.com/assets/uploads/gallery']: }
    file { ['/app/ugc/dogtime.com',
            '/app/ugc/dogtime.com/images',
            '/app/ugc/dogtime.com/assets',
            '/app/ugc/dogtime.com/assets/uploads',
            '/app/ugc/dogtime.com/assets/uploads/gallery']: }
    file { ['/app/ugc/beautyriot.com',
            '/app/ugc/beautyriot.com/images',
            '/app/ugc/beautyriot.com/assets',
            '/app/ugc/beautyriot.com/assets/uploads',
            '/app/ugc/beautyriot.com/assets/uploads/gallery']: }
    file { ['/app/ugc/evolvemediallc.com',
            '/app/ugc/evolvemediallc.com/images',
            '/app/ugc/evolvemediallc.com/assets',
            '/app/ugc/evolvemediallc.com/assets/uploads',
            '/app/ugc/evolvemediallc.com/assets/uploads/gallery']: }
    file { ['/app/ugc/ropeofsilicon.com',
            '/app/ugc/ropeofsilicon.com/images',
            '/app/ugc/ropeofsilicon.com/assets',
            '/app/ugc/ropeofsilicon.com/assets/uploads',
            '/app/ugc/ropeofsilicon.com/assets/uploads/gallery']: }
    file { ['/app/ugc/home.springboardplatform.com',
            '/app/ugc/home.springboardplatform.com/images',
            '/app/ugc/home.springboardplatform.com/assets',
            '/app/ugc/home.springboardplatform.com/assets/uploads',
            '/app/ugc/home.springboardplatform.com/assets/uploads/gallery']: }
    file { ['/app/ugc/studio.musicfeeds.com.au',
            '/app/ugc/studio.musicfeeds.com.au/images',
            '/app/ugc/studio.musicfeeds.com.au/assets',
            '/app/ugc/studio.musicfeeds.com.au/assets/uploads',
            '/app/ugc/studio.musicfeeds.com.au/assets/uploads/gallery']: }
    file { ['/app/ugc/awards.totalbeauty.com',
            '/app/ugc/awards.totalbeauty.com/images',
            '/app/ugc/awards.totalbeauty.com/assets',
            '/app/ugc/awards.totalbeauty.com/assets/uploads',
            '/app/ugc/awards.totalbeauty.com/assets/uploads/gallery']: }
    file { ['/app/ugc/mandatory.com',
            '/app/ugc/mandatory.com/images',
            '/app/ugc/mandatory.com/assets',
            '/app/ugc/mandatory.com/assets/uploads',
            '/app/ugc/mandatory.com/assets/uploads/gallery']: }


#### Internationalization symlinks
    file { '/app/ugc/craveonline.ca':
         ensure  => symlink,
         target  => '/app/ugc/craveonline.com'
    }
    file { '/app/ugc/craveonline.co.uk':
         ensure  => symlink,
         target  => '/app/ugc/craveonline.com'
    }
    file { '/app/ugc/craveonline.com.au':
         ensure  => symlink,
         target  => '/app/ugc/craveonline.com'
    }
    file { '/app/ugc/thefashionspot.ca':
         ensure  => symlink,
         target  => '/app/ugc/thefashionspot.com'
    }
    file { '/app/ugc/thefashionspot.com.au':
         ensure  => symlink,
         target  => '/app/ugc/thefashionspot.com'
    }
    file { '/app/ugc/theukfashionspot.co.uk':
         ensure  => symlink,
         target  => '/app/ugc/thefashionspot.com'
    }


}

############################################################################
##### APC Configuration for app servers ####################################
############################################################################
class wordpresspb::apc_config {

    file {"/etc/php.d/apc.ini": 
         ensure  => file,
         owner   => root,
         group   => root,
         mode    => 644,
         source  => "puppet:///modules/php/pbwp_apc.ini",
         require => Package["php56u-pecl-apcu"],
         }

}


############################################################################
##### Pebblebed Wordpress Database Sync Credentials ########################
############################################################################
class wordpresspb::pbwb_dbcred {

#### Set sync dbcred file default attributes
    File {
         owner  => "deploy",
         group  => "deploy",
         mode    => 644,
         }

#### Ensure directory structure exists
    file { ['/usr/local/bin/deploy', 
            '/usr/local/bin/deploy/dbcred', 
            '/usr/local/bin/deploy/dbcred/bta', 
            '/usr/local/bin/deploy/dbcred/sbx', 
            '/usr/local/bin/deploy/dbcred/dev', 
            '/usr/local/bin/deploy/dbcred/stg', 
            '/usr/local/bin/deploy/dbcred/www']:
         ensure => directory,
         }


#### Create BTA sync dbcred file
    $pbwpbtarwpw=decrypt("m92RDMe/L0M7hYs1oQmh5A==")
    $pbwpbtaropw=decrypt("3pw2PIMG7u2HWMJdX379CA==")
    file { "/usr/local/bin/deploy/dbcred/bta/pbwpdb.yml":
         ensure => file,
         content => template('atomiconline/bta_pbwpdb.yml'),
         }

#### Create UID sync dbcred file
    $pbwpuidrwpw=decrypt("Dtp6gGhl882HN56o5iokIA==")
    $pbwpuidropw=decrypt("8rr+VuAC2VcTn+DNVim9OQ==")
    file { "/usr/local/bin/deploy/dbcred/sbx/pbwpdb.yml":
         ensure => file,
         content => template('atomiconline/uid_pbwpdb.yml'),
         }

#### Create DEV sync dbcred file
    $pbwpdevropw=decrypt("1ZIDr8XYM9oE/pExcTFfag==")
    $pbwpdevrwpw=decrypt("CDn/InkOgbyy7AMa5pNKsg==")
    $pbmcdevropw=decrypt("Hcm3pBZwHNmSoGCLbmVR9Kw/u5hiHkk60a/ohsXTRV8=")
    $pbmcdevrwpw=decrypt("gv9sU+iTDZunGZr+ZWFTCZdMu0FXCognpX5jUkH6lCc=")
    $pbxfdevropw=decrypt("FXCPxLKwO99IZOIrO267hw==")
    $pbxfdevrwpw=decrypt("DBOgiADxYKuak8kictuPUg==")
    $pbxfpsldevropw=decrypt("FXCPxLKwO99IZOIrO267hw==")
    $pbxfpsldevrwpw=decrypt("DBOgiADxYKuak8kictuPUg==")
    $pbxfsdcdevropw=decrypt("BczGmJepjU1t0lXttT43Ig==")
    $pbxfaedevropw=decrypt("ayeWlo22ol0RcbfJmXvnNA==")
    $pbxfaedevrwpw=decrypt("ZbIVD3q595vSd9Enx6E5qg==")
    $pbxfsdcdevrwpw=decrypt("iOroJ3hCWcQD/Pu9aVOs7Q==")
    $pbxfhfbdevropw=decrypt("7ggxxxA8WhiPCk1GbfoFQQ==")
    $pbxfhfbdevrwpw=decrypt("w8cJ32/jDpRyrOyNp4XI6g==")
    $pbxfwzdevropw=decrypt("bcUdNAr/s6pUkP6RDmgdmA==")
    $pbxfwzdevrwpw=decrypt("QElKL2Z2/CMtez1CJ0sHNA==")
    $apicsdevropw=decrypt("hLXVSO2VWZS8KzEG7B99XQ==")
    $apicsdevrwpw=decrypt("wOXk2smbop/VaSfeuoGB8A==")
    $pbsdcdevropw=decrypt("Ukkti5VCQIt5OWxqyic0PQ==")
    $pbsdcdevrwpw=decrypt("8JwQiW/XXzMIJXFbXn8EbA==")
    $apidfpdevropw=decrypt("1JbIYp/hvygUiXLY/wy+dA==")
    $apidfpdevrwpw=decrypt("LJgsAPqLx7kIquPD0aJ86A==")
    file { "/usr/local/bin/deploy/dbcred/dev/pbwpdb.yml":
         ensure => file,
         content => template('atomiconline/dev_pbwpdb.yml'),
         }

#### Create STG sync dbcred file
    $pbwpstgropw=decrypt("Q/TEMtPkc67LGn4rMbVT9w==")
    $pbwpstgrwpw=decrypt("hfSVcMXAEjU3Dw7MTIoQCw==")
    $pbmcstgropw=decrypt("16gDMbV7NfFroDMIygTQBQ==")
    $pbmcstgrwpw=decrypt("wLo5jecPpflLNIGd22S0LA==")
    $pbxfstgropw=decrypt("9oxsT8fPe+PDU8PQhpXCyQ==")
    $pbxfstgrwpw=decrypt("4eXrrC57XZyXw6nNm5T13Q==")
    $pbxfpslstgropw=decrypt("9oxsT8fPe+PDU8PQhpXCyQ==")
    $pbxfpslstgrwpw=decrypt("4eXrrC57XZyXw6nNm5T13Q==")
    $pbxfsdcstgropw=decrypt("OSoodvECzLAX6vDp0Y9Wmw==")
    $pbxfsdcstgrwpw=decrypt("Mv486PVWE/mmTiUvFYeHRw==")
    $pbxfaestgropw=decrypt("C1rhwvx62lNlPTs7CEBTBA==")
    $pbxfaestgrwpw=decrypt("vlWjrwuFklm+Bh9/O0PnLQ==")
    $pbxfhfbstgropw=decrypt("m0I+tAaZKlcSYkXajH8l5A==")
    $pbxfhfbstgrwpw=decrypt("odu4A1YxzdkUtIiFYHut7w==")
    $pbxfwzstgropw=decrypt("F5mvrJ2Pojntia121jXaFA==")
    $pbxfwzstgrwpw=decrypt("toR7q32/c1vDP/q5riqjUA==")
    $apicsstgropw=decrypt("vLyaY50u3eSHJwQBiYW7Hw==")
    $apicsstgrwpw=decrypt("hX+giBB3Cjs2P4pYAdfIAg==")
    $pbsdcstgropw=decrypt("r5j9TQdw+nefqbRvXAse8A==")
    $pbsdcstgrwpw=decrypt("4hJ1CsPxev8At+aIoM31EQ==")
    $apidfpstgropw=decrypt("ZuBl0fZaty/2XKKbQAkRhQ==")
    $apidfpstgrwpw=decrypt("2QLPBNYb6ryJr9TO1ebRMg==")
    file { "/usr/local/bin/deploy/dbcred/stg/pbwpdb.yml":
         ensure => file,
         content => template('atomiconline/stg_pbwpdb.yml'),
         }

#### Create PRD sync dbcred file
    $pbwpprdropw=decrypt("NUBGExsRUwpqXTiGK8UFzQ==")
    $pbmcprdropw=decrypt("42YxP3QXxyHf+4K2LsW8LH/U/s1AZynOSbTa0dasr5Y=")
    $pbxfprdropw=decrypt("LMDuwLcYvtsOEYHyUwMAeg==")
    $pbxfpslprdropw=decrypt("LMDuwLcYvtsOEYHyUwMAeg==")
    $pbxfsdcprdropw=decrypt("q/xz981uQ9HZenrRr04M6Q==")
    $pbxfaeprdropw=decrypt("tg0UfQNYdz2ccl3Hy5zvLA==")
    $pbxfhfbprdropw=decrypt("/mrR65zDzgdT+uNntlDPLA==")
    $pbxfwzprdropw=decrypt("nb4YEQSw2hlDEAHn87Ah+g==")
    $apicsprdropw=decrypt("kpDt6Z4g2Xfn0TV3DV40gA==")
    $pbsdcprdropw=decrypt("Y3djLYTwZYRkR08aWwdZvA==")
    $apidfpprdropw=decrypt("OCwEpuEFJms3SjxGLDtDIw==")
    file { "/usr/local/bin/deploy/dbcred/www/pbwpdb.yml":
         ensure => file,
         content => template('atomiconline/prd_pbwpdb.yml'),
         }

}


############################################################################
##### Pebblebed Wordpress Database Credentials for APP DEV #################
############################################################################
class wordpresspb::pbwb_appdev_dbcred {

#### Set dev dbcred file default attributes
    File {
         ensure => file,
         owner  => "deploy",
         group  => "deploy",
         mode    => 644,
         }

#### Create ruckus dev dbcred file
    $devpbwpruckus=decrypt("tYAj2SKMvzPA7MA//ldZzg==")
    file { "/app/shared/wordpress/dbcred/ruckus_database.inc.php":
         content => template('atomiconline/dev_ruckus_database.inc.php'),
         }

#### Create hockeysfuture.com dev dbcred file
    $devpbwphockeysfuturerw=decrypt("aS+K/APtScz3KKejKYkjIQ==")
    $devpbwphockeysfuturero=decrypt("XP7NDOQR/1k+MZFAhJYZtg==")
    file { "/app/shared/wordpress/dbcred/db_hockeysfuture.com.php":
         content => template('atomiconline/dev_db_hockeysfuture.com.php'),
         }

#### Create pbwp.gnmedia.net dev dbcred file
    $devpbwpgnmediarw=decrypt("CaCOYvM/NDP9iUJIItKk0Q==")
    $devpbwpgnmediaro=decrypt("wNujCfrZKZet368mqbNtow==")
    file { "/app/shared/wordpress/dbcred/db_pbwp.gnmedia.net.php":
         content => template('atomiconline/dev_db_pbwp.gnmedia.net.php'),
         }

#### Create playstationlifestyle.net dev dbcred file
    $devpbwpplaystationlifestylerw=decrypt("WyvrNCNO7FSbBBFAY2D5Zw==")
    $devpbwpplaystationlifestylero=decrypt("CYs2GNc9WZVceHHR0fiJ0A==")
    file { "/app/shared/wordpress/dbcred/db_playstationlifestyle.net.php":
         content => template('atomiconline/dev_db_playstationlifestyle.net.php'),
         }

#### Create realitytea.com dev dbcred file
  $devpbwprealitytearw=decrypt("nbCO52FnNn+NceK3+kj/LA==")
  $devpbwprealitytearo=decrypt("EuEweCAkWS74WVC/gr9YFA==")
    file { "/app/shared/wordpress/dbcred/db_realitytea.com.php":
         content => template('atomiconline/dev_db_realitytea.com.php'),
         }

#### Create craveonline.com dev dbcred file
  $devpbwp_craveonlinero=decrypt("MGCCDYNL4yz7O6CNYMugjg==")
  $devpbwp_craveonlinerw=decrypt("Dizmz0qtW0a7FzjsS2Tx3A==")
    file { "/app/shared/wordpress/dbcred/db_craveonline.com.php":
         content => template('atomiconline/dev_db_craveonline.com.php'),
         }

#### Create idly.craveonline.com dev dbcred file
  $devpbwp_idlyitwro=decrypt("/gxVczKE0Z9btLoLeNqnHg==")
  $devpbwp_idlyitwrw=decrypt("1vulDKZ2ThSUCatkvzPrFQ==")
    file { "/app/shared/wordpress/dbcred/db_idly.craveonline.com.php":
         content => template('atomiconline/dev_db_idly.craveonline.com.php'),
         }

#### Create thefashionspot.com dev dbcred file
  $devpbwp_thefashionspotro=decrypt("DPILjfxN9b8b3BWzeeC8rA==")
  $devpbwp_thefashionspotrw=decrypt("YJllQNg386zf+s/Fheyxsg==")
    file { "/app/shared/wordpress/dbcred/db_thefashionspot.com.php":
         content => template('atomiconline/dev_db_thefashionspot.com.php'),
         }
         
#devtoken

#### Create mandatory.com dev dbcred file
  $devpbwp_mandatoryro=decrypt("HPrBlOfMmQpsjG4ksNpZLg==")
  $devpbwp_mandatoryrw=decrypt("h80Mjph09OLG1FDfH49n/Q==")
    file { "/app/shared/wordpress/dbcred/db_mandatory.com.php":
         content => template('atomiconline/dev_db_mandatory.com.php'),
         }


#### Create awards.totalbeauty.com dev dbcred file
  $devpbwp_awards_totalbeautyro=decrypt("O66P2GBja4pRtNF7HKvptg==")
  $devpbwp_awards_totalbeautyrw=decrypt("wSndrGgABcz7xDv7FrxBgw==")
    file { "/app/shared/wordpress/dbcred/db_awards.totalbeauty.com.php":
         content => template('atomiconline/dev_db_awards.totalbeauty.com.php'),
         }


#### Create studio.musicfeeds.com.au dev dbcred file
  $devpbwp_studio_musicfeedsro=decrypt("+d2RD1/eooaTUNZCMb6DuA==")
  $devpbwp_studio_musicfeedsrw=decrypt("+pHgrqZ5Wm8+v1qAPqFumg==")
    file { "/app/shared/wordpress/dbcred/db_studio.musicfeeds.com.au.php":
         content => template('atomiconline/dev_db_studio.musicfeeds.com.au.php'),
         }

#### Create ropeofsilicon.com dev dbcred file
  $devpbwp_ropeofsiliconro=decrypt("cx6f67rHn8q+tus94vj0Dw==")
  $devpbwp_ropeofsiliconrw=decrypt("Ae2ho+lyrjODG5LpfPjyqg==")
    file { "/app/shared/wordpress/dbcred/db_ropeofsilicon.com.php":
         content => template('atomiconline/dev_db_ropeofsilicon.com.php'),
         }

#### Create dogtime.com dev dbcred file
  $devpbwp_dogtimero=decrypt("8ZbBWZhZi0ZvNuK1AaK9Kg==")
  $devpbwp_dogtimerw=decrypt("9+Wt/t89Q2HGUrm50p1rig==")
    file { "/app/shared/wordpress/dbcred/db_dogtime.com.php":
         content => template('atomiconline/dev_db_dogtime.com.php'),
         }

#### Create base.evolvemediallc.com dev dbcred file
  $devpbwp_basero=decrypt("UbKhb3ccyRSMcl3t4hrnNA==")
  $devpbwp_baserw=decrypt("Dv7RN2q54vqG9NrMvl3QCg==")
    file { "/app/shared/wordpress/dbcred/db_base.evolvemediallc.com.php":
         content => template('atomiconline/dev_db_base.evolvemediallc.com.php'),
         }

#### Create musicfeeds.com.au dev dbcred file
  $devpbwp_musicfeedsro=decrypt("ZbRX1Qm9ku5fZuETLSwXUA==")
  $devpbwp_musicfeedsrw=decrypt("xxiKUbY8iRXCTYDuFRsZRA==")
    file { "/app/shared/wordpress/dbcred/db_musicfeeds.com.au.php":
         content => template('atomiconline/dev_db_musicfeeds.com.au.php'),
         }

#### Create cattime.com dev dbcred file
  $devpbwp_cattimero=decrypt("ZVCvKpodwzeMve076pS+jw==")
  $devpbwp_cattimerw=decrypt("DBGx+HwnlJkKnzHI8TjGvQ==")
    file { "/app/shared/wordpress/dbcred/db_cattime.com.php":
         content => template('atomiconline/dev_db_cattime.com.php'),
         }

#### Create beautyriot.com dev dbcred file
  $devpbwp_beautyriotro=decrypt("DyQMq+EKhBdP8Gewgiz0Zg==")
  $devpbwp_beautyriotrw=decrypt("4ZynFd1aFBuhSVc9TCwR4w==")
    file { "/app/shared/wordpress/dbcred/db_beautyriot.com.php":
         content => template('atomiconline/dev_db_beautyriot.com.php'),
         }

#### Create evolvemediallc.com dev dbcred file
  $devpbwp_evolvemediallcro=decrypt("9SYJiJPT9WBR8bfwO8oPvw==")
  $devpbwp_evolvemediallcrw=decrypt("6p/QwsmAgkaeRcljLq8rHw==")
    file { "/app/shared/wordpress/dbcred/db_evolvemediallc.com.php":
         content => template('atomiconline/dev_db_evolvemediallc.com.php'),
         }

#### Create totallykidz.com dev dbcred file
  $devpbwp_totallykidzro=decrypt("kMVbaZF/GurXC0cJ4aR96w==")
  $devpbwp_totallykidzrw=decrypt("gf+SDVoBLRrdSJbY8zglIg==")
    file { "/app/shared/wordpress/dbcred/db_totallykidz.com.php":
         content => template('atomiconline/dev_db_totallykidz.com.php'),
         }

#### Create afterellen.com dev dbcred file
  $devpbwp_afterellenro=decrypt("EjC5rY93kn0pmvIz6crMug==")
  $devpbwp_afterellenrw=decrypt("v2rKpgxO1BxwvEu87HAq1Q==")
    file { "/app/shared/wordpress/dbcred/db_afterellen.com.php":
         content => template('atomiconline/dev_db_afterellen.com.php'),
         }

#### Create home.springboardplatform.com dev dbcred file
  $devpbwp_springboardro=decrypt("hRjaf1mdUAAfoDpv+UCazQ==")
  $devpbwp_springboardrw=decrypt("DWVZJbiye+ZAHT9pJ7xALQ==")
    file { "/app/shared/wordpress/dbcred/db_home.springboardplatform.com.php":
         content => template('atomiconline/dev_db_home.springboardplatform.com.php'),
         }

#### Create totallyhermedia.com dev dbcred file
  $devpbwp_totallyhermediaro=decrypt("f1BFQLy1APaBOeINDC2RhA==")
  $devpbwp_totallyhermediarw=decrypt("yX3Q19ZzMWjCRpyjF34alg==")
    file { "/app/shared/wordpress/dbcred/db_totallyhermedia.com.php":
         content => template('atomiconline/dev_db_totallyhermedia.com.php'),
         }

#### Create craveonlinemedia.com dev dbcred file
  $devpbwp_craveonlinemediaro=decrypt("bSFueUWswYnAToD7UHWeHw==")
  $devpbwp_craveonlinemediarw=decrypt("IJlcnOy+9Q1N3hNWJuGDvA==")
    file { "/app/shared/wordpress/dbcred/db_craveonlinemedia.com.php":
         content => template('atomiconline/dev_db_craveonlinemedia.com.php'),
         }

#### Create webecoist.momtastic.com dev dbcred file
  $devpbwp_webecoistro=decrypt("SvDZEYt2tX5fZdHT7M+qag==")
  $devpbwp_webecoistrw=decrypt("5g3TxlbnwfMeZH0zXvL0Tw==")
    file { "/app/shared/wordpress/dbcred/db_webecoist.momtastic.com.php":
         content => template('atomiconline/dev_db_webecoist.momtastic.com.php'),
         }

#### Create comingsoon.net dev dbcred file
  $devpbwp_comingsoonro=decrypt("4Rwz/kLLPE/Qa5rPM+0Djg==")
  $devpbwp_comingsoonrw=decrypt("xq2CUO4z0K12SbpYq+9BRQ==")
    file { "/app/shared/wordpress/dbcred/db_comingsoon.net.php":
         content => template('atomiconline/dev_db_comingsoon.net.php'),
         }

#### Create ringtv.craveonline.com dev dbcred file
  $devpbwp_ringtvro=decrypt("0p9v8bT3sDidiAtMckZ9yg==")
  $devpbwp_ringtvrw=decrypt("eGzo5AVemmWYEhyASxVKqA==")
    file { "/app/shared/wordpress/dbcred/db_ringtv.craveonline.com.php":
         content => template('atomiconline/dev_db_ringtv.craveonline.com.php'),
         }

#### Create superherohype.com dev dbcred file
  $devpbwp_superherohypero=decrypt("FvDZNn7JsPqcMj5PjLjG8w==")
  $devpbwp_superherohyperw=decrypt("2bA06d/1q2wlFS0Nk/D3OQ==")
    file { "/app/shared/wordpress/dbcred/db_superherohype.com.php":
         content => template('atomiconline/dev_db_superherohype.com.php'),
         }

#### Create shocktillyoudrop.com dev dbcred file
  $devpbwp_shocktillyoudropro=decrypt("DV7mEX2SgCe/B4+8tsvRjg==")
  $devpbwp_shocktillyoudroprw=decrypt("f1wAg3UQnqu+luCrArQIHQ==")
    file { "/app/shared/wordpress/dbcred/db_shocktillyoudrop.com.php":
         content => template('atomiconline/dev_db_shocktillyoudrop.com.php'),
         }

#### Create momtastic.com dev dbcred file
  $devpbwp_momtasticro=decrypt("Id00xOzSjWX3GtJk4sq9UA==")
  $devpbwp_momtasticrw=decrypt("YHzH1s37J4plYlYwKC9Iuw==")
    file { "/app/shared/wordpress/dbcred/db_momtastic.com.php":
         content => template('atomiconline/dev_db_momtastic.com.php'),
         }

#### Create mumtasticuk.co.uk dev dbcred file
  $devpbwp_mumtasticukro=decrypt("fOi0d2PbqOIP+/p2/+OPRA==")
  $devpbwp_mumtasticukrw=decrypt("JamDSGykNxneRmCiCeBWBA==")
    file { "/app/shared/wordpress/dbcred/db_mumtasticuk.co.uk.php":
         content => template('atomiconline/dev_db_mumtasticuk.co.uk.php'),
         }

#### Create momtastic.com.au dev dbcred file
  $devpbwp_momtasticauro=decrypt("RFc+lRBqCN1kt2xgD6ZhlA==")
  $devpbwp_momtasticaurw=decrypt("AerBL6HcEplhJRzyBNXt+w==")
    file { "/app/shared/wordpress/dbcred/db_momtastic.com.au.php":
         content => template('atomiconline/dev_db_momtastic.com.au.php'),
         }

#### Create wrestlezone.com dev dbcred file
  $devpbwp_wrestlezonero=decrypt("wYTCVWGMBhK6vUttlB2TMA==")
  $devpbwp_wrestlezonerw=decrypt("J0rELDt/o78RO/NrRPupjQ==")
    file { "/app/shared/wordpress/dbcred/db_wrestlezone.com.php":
         content => template('atomiconline/dev_db_wrestlezone.com.php'),
         }

#### Create liveoutdoors.com dev dbcred file
  $devpbwp_liveoutdoorsro=decrypt("UJzLSIcZDyU7VdtcM7t5Wg==")
  $devpbwp_liveoutdoorsrw=decrypt("0VSrDa/wrYxWX3ts4Ym4Jw==")
    file { "/app/shared/wordpress/dbcred/db_liveoutdoors.com.php":
         content => template('atomiconline/dev_db_liveoutdoors.com.php'),
         }

#### Create hoopsvibe.com dev dbcred file
  $devpbwp_hoopsvibero=decrypt("wXpcbjaEqSe/g0XmTAzzJw==")
  $devpbwp_hoopsviberw=decrypt("IM50msrrQC9lae+sBt9zbA==")
    file { "/app/shared/wordpress/dbcred/db_hoopsvibe.com.php":
         content => template('atomiconline/dev_db_hoopsvibe.com.php'),
         }

#### Create wholesomebabyfood.momtastic.com dev dbcred file
  $devpbwp_wholesomebabyfoodro=decrypt("PQsHKEpgBKUiXDY0CevXmA==")
  $devpbwp_wholesomebabyfoodrw=decrypt("CfQc7vDFetMrkL0mCZ2usQ==")
    file { "/app/shared/wordpress/dbcred/db_wholesomebabyfood.momtastic.com.php":
         content => template('atomiconline/dev_db_wholesomebabyfood.momtastic.com.php'),
         }

#### Create totallyher.com dev dbcred file
  $devpbwp_totallyherro=decrypt("VKpTE2IIWefYj1wkLlLLIg==")
  $devpbwp_totallyherrw=decrypt("FVL73DQR66sWw8m17bZCsQ==")
    file { "/app/shared/wordpress/dbcred/db_totallyher.com.php":
         content => template('atomiconline/dev_db_totallyher.com.php'),
         }

#### Create bufferzone.craveonline.com dev dbcred file
  $devpbwp_bufferzonero=decrypt("DJyjqIAZT7pCTcIE+/DnCA==")
  $devpbwp_bufferzonerw=decrypt("jLkFAmNjw4PHxpc9z2HiOA==")
    file { "/app/shared/wordpress/dbcred/db_bufferzone.craveonline.com.php":
         content => template('atomiconline/dev_db_bufferzone.craveonline.com.php'),
         }

}


############################################################################
##### Pebblebed Wordpress Database Credentials for APP STG #################
############################################################################
class wordpresspb::pbwb_appstg_dbcred {

#### Set stg dbcred file default attributes
    File {
         ensure => file,
         owner  => "deploy",
         group  => "deploy",
         mode    => 644,
         }

#### Create ruckus stg dbcred file
    $stgpbwpruckus=decrypt("dXv6IWMCfsQxehOvWddlig==")
    file { "/app/shared/wordpress/dbcred/ruckus_database.inc.php":
         content => template('atomiconline/stg_ruckus_database.inc.php'),
         }

#### Create hockeysfuture.com stg dbcred file
    $stgpbwphockeysfuturerw=decrypt("rT6obSwMn+dhIGEp392uPw==")
    $stgpbwphockeysfuturero=decrypt("T96K5Dx/gRO/smjL4IzJPQ==")
    file { "/app/shared/wordpress/dbcred/db_hockeysfuture.com.php":
         content => template('atomiconline/stg_db_hockeysfuture.com.php'),
         }

#### Create pbwp.gnmedia.net stg dbcred file
    $stgpbwpgnmediarw=decrypt("zAP9uKimP8DLyWeJhxNqag==")
    $stgpbwpgnmediaro=decrypt("hs7+DR4N5N1wNQugVopRTw==")
    file { "/app/shared/wordpress/dbcred/db_pbwp.gnmedia.net.php":
         content => template('atomiconline/stg_db_pbwp.gnmedia.net.php'),
         }

#### Create playstationlifestyle.net stg dbcred file
    $stgpbwpplaystationlifestylerw=decrypt("NbBPXzqcUubaNmcCCrFSAg==")
    $stgpbwpplaystationlifestylero=decrypt("iSG3HkjZhbUt+6gYCGIO8A==")
    file { "/app/shared/wordpress/dbcred/db_playstationlifestyle.net.php":
         content => template('atomiconline/stg_db_playstationlifestyle.net.php'),
         }

#### Create realitytea.com stg dbcred file
  $stgpbwprealitytearw=decrypt("8f0LPFEph4lIc7fQB7sCfg==")
  $stgpbwprealitytearo=decrypt("pQ9+uDQyc8jweQreupchiw==")
    file { "/app/shared/wordpress/dbcred/db_realitytea.com.php":
         content => template('atomiconline/stg_db_realitytea.com.php'),
         }

#### Create craveonline.com stg dbcred file
  $stgpbwp_craveonlinero=decrypt("TjbfvM42/Bo5IfW29qGFdw==")
  $stgpbwp_craveonlinerw=decrypt("CPN1sy+JB3tkJRluGirDZg==")
    file { "/app/shared/wordpress/dbcred/db_craveonline.com.php":
         content => template('atomiconline/stg_db_craveonline.com.php'),
         }

#### Create thefashionspot.com stg dbcred file
  $stgpbwp_thefashionspotro=decrypt("y6mZwwivd/QFgTiZ9C2zNA==")
  $stgpbwp_thefashionspotrw=decrypt("aCh6/K6IDBu1z05W3DAIxw==")
    file { "/app/shared/wordpress/dbcred/db_thefashionspot.com.php":
         content => template('atomiconline/stg_db_thefashionspot.com.php'),
         }

#### Create idly.craveonline.com stg dbcred file
  $stgpbwp_idlyitwro=decrypt("BirKedaHo90pDGe8nT8uAA==")
  $stgpbwp_idlyitwrw=decrypt("m+/4Y2BiX2Pn8iv3riHWXA==")
    file { "/app/shared/wordpress/dbcred/db_idly.craveonline.com.php":
         content => template('atomiconline/stg_db_idly.craveonline.com.php'),
         }

#stgtoken


#### Create mandatory.com stg dbcred file
  $stgpbwp_mandatoryro=decrypt("b7t/2m48sWK6bv3E0e2Dcg==")
  $stgpbwp_mandatoryrw=decrypt("7Ehr4GZQHzDYkkQn7aq2Og==")
    file { "/app/shared/wordpress/dbcred/db_mandatory.com.php":
         content => template('atomiconline/stg_db_mandatory.com.php'),
         }


#### Create awards.totalbeauty.com stg dbcred file
  $stgpbwp_awards_totalbeautyro=decrypt("/rMABCgYCU3eor/VqaIAHw==")
  $stgpbwp_awards_totalbeautyrw=decrypt("h384Fz8cm6prnqMjFDjFQQ==")
    file { "/app/shared/wordpress/dbcred/db_awards.totalbeauty.com.php":
         content => template('atomiconline/stg_db_awards.totalbeauty.com.php'),
         }


#### Create studio.musicfeeds.com.au stg dbcred file
  $stgpbwp_studio_musicfeedsro=decrypt("IKkNTgPhBoyhigHEjtcuug==")
  $stgpbwp_studio_musicfeedsrw=decrypt("uEXpDMto3ReX2AjBGzpf/Q==")
    file { "/app/shared/wordpress/dbcred/db_studio.musicfeeds.com.au.php":
         content => template('atomiconline/stg_db_studio.musicfeeds.com.au.php'),
         }
         
#### Create ropeofsilicon.com stg dbcred file
  $stgpbwp_ropeofsiliconro=decrypt("ifdV/d0LiFA6HXFwOgYuwQ==")
  $stgpbwp_ropeofsiliconrw=decrypt("7f8h5J9tGqGvPsL1gMkrYg==")
    file { "/app/shared/wordpress/dbcred/db_ropeofsilicon.com.php":
         content => template('atomiconline/stg_db_ropeofsilicon.com.php'),
         }

#### Create dogtime.com stg dbcred file
  $stgpbwp_dogtimero=decrypt("bY66wP9YqS5Ij2+rDDeGVw==")
  $stgpbwp_dogtimerw=decrypt("Yzk338XTbL8VfdQxlpjvIw==")
    file { "/app/shared/wordpress/dbcred/db_dogtime.com.php":
         content => template('atomiconline/stg_db_dogtime.com.php'),
         }

#### Create base.evolvemediallc.com stg dbcred file
  $stgpbwp_basero=decrypt("7gsIOYEIAqFO+DQE5Rwrag==")
  $stgpbwp_baserw=decrypt("du+A2w4oEGT51rQc6ejw5A==")
    file { "/app/shared/wordpress/dbcred/db_base.evolvemediallc.com.php":
         content => template('atomiconline/stg_db_base.evolvemediallc.com.php'),
         }

#### Create musicfeeds.com.au stg dbcred file
  $stgpbwp_musicfeedsro=decrypt("1AWBJwKfSYCi1eu7uZSdDQ==")
  $stgpbwp_musicfeedsrw=decrypt("qWMx0IKVPmq32LhPeFijGQ==")
    file { "/app/shared/wordpress/dbcred/db_musicfeeds.com.au.php":
         content => template('atomiconline/stg_db_musicfeeds.com.au.php'),
         }

#### Create cattime.com stg dbcred file
  $stgpbwp_cattimero=decrypt("Gb1eH4iasH+TmXNhai/l3w==")
  $stgpbwp_cattimerw=decrypt("CA/47dvZsHhDFf9jJQkPfg==")
    file { "/app/shared/wordpress/dbcred/db_cattime.com.php":
         content => template('atomiconline/stg_db_cattime.com.php'),
         }

#### Create beautyriot.com stg dbcred file
  $stgpbwp_beautyriotro=decrypt("RrCKAX2fTm8aPLwlLXTi5Q==")
  $stgpbwp_beautyriotrw=decrypt("7/KP0/EFxPliIyC5Gk5QtQ==")
    file { "/app/shared/wordpress/dbcred/db_beautyriot.com.php":
         content => template('atomiconline/stg_db_beautyriot.com.php'),
         }

#### Create evolvemediallc.com stg dbcred file
  $stgpbwp_evolvemediallcro=decrypt("gQDc7ozw+Whv4Pir+vJHIw==")
  $stgpbwp_evolvemediallcrw=decrypt("CheE8dhukf0ygrRoXOr/gw==")
    file { "/app/shared/wordpress/dbcred/db_evolvemediallc.com.php":
         content => template('atomiconline/stg_db_evolvemediallc.com.php'),
         }

#### Create totallykidz.com stg dbcred file
  $stgpbwp_totallykidzro=decrypt("JLKSDDJ2efxHd3VlvyZbKg==")
  $stgpbwp_totallykidzrw=decrypt("lQnDMehjsvzAhBnOfdUwJQ==")
    file { "/app/shared/wordpress/dbcred/db_totallykidz.com.php":
         content => template('atomiconline/stg_db_totallykidz.com.php'),
         }

#### Create afterellen.com stg dbcred file
  $stgpbwp_afterellenro=decrypt("TfReVqHFPlsnPCai/WeUMw==")
  $stgpbwp_afterellenrw=decrypt("HB25hYctvdUOPfj+REWG5A==")
    file { "/app/shared/wordpress/dbcred/db_afterellen.com.php":
         content => template('atomiconline/stg_db_afterellen.com.php'),
         }

#### Create home.springboardplatform.com stg dbcred file
  $stgpbwp_springboardro=decrypt("7XXatZnY5pi9scb0CNe7ZA==")
  $stgpbwp_springboardrw=decrypt("2FmN5Zs3dHJtT1v+D+oSeA==")
    file { "/app/shared/wordpress/dbcred/db_home.springboardplatform.com.php":
         content => template('atomiconline/stg_db_home.springboardplatform.com.php'),
         }

#### Create totallyhermedia.com stg dbcred file
  $stgpbwp_totallyhermediaro=decrypt("pOnWVRyDw2YjGZh89rX1cA==")
  $stgpbwp_totallyhermediarw=decrypt("oVTgfC+d7O+kESmGy/w98w==")
    file { "/app/shared/wordpress/dbcred/db_totallyhermedia.com.php":
         content => template('atomiconline/stg_db_totallyhermedia.com.php'),
         }

#### Create craveonlinemedia.com stg dbcred file
  $stgpbwp_craveonlinemediaro=decrypt("RtvgYSmTM+ri98ilx1Z64A==")
  $stgpbwp_craveonlinemediarw=decrypt("M0+fPb+LHgKkciKUwOfvGw==")
    file { "/app/shared/wordpress/dbcred/db_craveonlinemedia.com.php":
         content => template('atomiconline/stg_db_craveonlinemedia.com.php'),
         }

#### Create webecoist.momtastic.com stg dbcred file
  $stgpbwp_webecoistro=decrypt("zKrzJpaL3NBBxChE1xZPBA==")
  $stgpbwp_webecoistrw=decrypt("Gb5q985+Fy3nLGx5ZkQfig==")
    file { "/app/shared/wordpress/dbcred/db_webecoist.momtastic.com.php":
         content => template('atomiconline/stg_db_webecoist.momtastic.com.php'),
         }

#### Create comingsoon.net stg dbcred file
  $stgpbwp_comingsoonro=decrypt("ol1hJHRD5druKAFnYU7W+Q==")
  $stgpbwp_comingsoonrw=decrypt("TikXidxSrTVXPaWwS4s+uA==")
    file { "/app/shared/wordpress/dbcred/db_comingsoon.net.php":
         content => template('atomiconline/stg_db_comingsoon.net.php'),
         }

#### Create ringtv.craveonline.com stg dbcred file
  $stgpbwp_ringtvro=decrypt("PHECrrJr3xxjuD7NptL7zQ==")
  $stgpbwp_ringtvrw=decrypt("HkoaKsvGh4Xsnae6zKQEPg==")
    file { "/app/shared/wordpress/dbcred/db_ringtv.craveonline.com.php":
         content => template('atomiconline/stg_db_ringtv.craveonline.com.php'),
         }

#### Create superherohype.com stg dbcred file
  $stgpbwp_superherohypero=decrypt("8rNTvip1bfCV5F4v4Qy8+g==")
  $stgpbwp_superherohyperw=decrypt("z3yn2m4XLGF/iDRdw/zyJg==")
    file { "/app/shared/wordpress/dbcred/db_superherohype.com.php":
         content => template('atomiconline/stg_db_superherohype.com.php'),
         }

#### Create shocktillyoudrop.com stg dbcred file
  $stgpbwp_shocktillyoudropro=decrypt("YfS2x7cq+eNF2QWCty6KbA==")
  $stgpbwp_shocktillyoudroprw=decrypt("9zi26vgbmYqEgU1nAiOJIw==")
    file { "/app/shared/wordpress/dbcred/db_shocktillyoudrop.com.php":
         content => template('atomiconline/stg_db_shocktillyoudrop.com.php'),
         }

#### Create momtastic.com stg dbcred file
  $stgpbwp_momtasticro=decrypt("5NfnwMDwyhjTudXDomYJiQ==")
  $stgpbwp_momtasticrw=decrypt("UK/Wz0bGwcfadbmaIWt55A==")
    file { "/app/shared/wordpress/dbcred/db_momtastic.com.php":
         content => template('atomiconline/stg_db_momtastic.com.php'),
         }

#### Create mumtasticuk.co.uk stg dbcred file
  $stgpbwp_mumtasticukro=decrypt("ncgKp6m4LYmuKOD09r2cVQ==")
  $stgpbwp_mumtasticukrw=decrypt("EKhGpRZ8lhqYX3kpgqUBDw==")
    file { "/app/shared/wordpress/dbcred/db_mumtasticuk.co.uk.php":
         content => template('atomiconline/stg_db_mumtasticuk.co.uk.php'),
         }

#### Create momtastic.com.au stg dbcred file
  $stgpbwp_momtasticauro=decrypt("CmsKo4smKLaDtjc8oIg9EA==")
  $stgpbwp_momtasticaurw=decrypt("/8zrm1YmGHO2xSi2ks8mjw==")
    file { "/app/shared/wordpress/dbcred/db_momtastic.com.au.php":
         content => template('atomiconline/stg_db_momtastic.com.au.php'),
         }

#### Create wrestlezone.com stg dbcred file
  $stgpbwp_wrestlezonero=decrypt("6Q8+ALETh6hLIEHL2u7CuA==")
  $stgpbwp_wrestlezonerw=decrypt("4pHw3Musoim7OkgnPhQFJg==")
    file { "/app/shared/wordpress/dbcred/db_wrestlezone.com.php":
         content => template('atomiconline/stg_db_wrestlezone.com.php'),
         }

#### Create liveoutdoors.com stg dbcred file
  $stgpbwp_liveoutdoorsro=decrypt("90UCKQhQuwgYqq9Dneu3fw==")
  $stgpbwp_liveoutdoorsrw=decrypt("BjHkESeJd+DQmatdtKDMUQ==")
    file { "/app/shared/wordpress/dbcred/db_liveoutdoors.com.php":
         content => template('atomiconline/stg_db_liveoutdoors.com.php'),
         }

#### Create hoopsvibe.com stg dbcred file
  $stgpbwp_hoopsvibero=decrypt("KmOtyms5uzjT+a4XlZDrjQ==")
  $stgpbwp_hoopsviberw=decrypt("4JRFxU3MKeKBQgUNZidixw==")
    file { "/app/shared/wordpress/dbcred/db_hoopsvibe.com.php":
         content => template('atomiconline/stg_db_hoopsvibe.com.php'),
         }

#### Create wholesomebabyfood.momtastic.com stg dbcred file
  $stgpbwp_wholesomebabyfoodro=decrypt("AYyHpC8pl8QcLkEw7sqthA==")
  $stgpbwp_wholesomebabyfoodrw=decrypt("NEQxADOrwrfkLZA8cY66ow==")
    file { "/app/shared/wordpress/dbcred/db_wholesomebabyfood.momtastic.com.php":
         content => template('atomiconline/stg_db_wholesomebabyfood.momtastic.com.php'),
         }

#### Create totallyher.com stg dbcred file
  $stgpbwp_totallyherro=decrypt("QREUjgvZBM85PPPK3aCCxg==")
  $stgpbwp_totallyherrw=decrypt("6r44Y4yONEm6Z5ZK0IJTMQ==")
    file { "/app/shared/wordpress/dbcred/db_totallyher.com.php":
         content => template('atomiconline/stg_db_totallyher.com.php'),
         }

#### Create bufferzone.craveonline.com stg dbcred file
  $stgpbwp_bufferzonero=decrypt("EXcIg/j3WWoRvXFztIvPYg==")
  $stgpbwp_bufferzonerw=decrypt("gr2WdKSjIbl/1aEDra65fA==")
    file { "/app/shared/wordpress/dbcred/db_bufferzone.craveonline.com.php":
         content => template('atomiconline/stg_db_bufferzone.craveonline.com.php'),
         }

}


############################################################################
##### Pebblebed Wordpress Database Credentials for APP PRD #################
############################################################################
class wordpresspb::pbwb_appprd_dbcred {

#### Set prd dbcred file default attributes
    File {
         ensure => file,
         owner  => "deploy",
         group  => "deploy",
         mode    => 644,
         }

#### Create ruckus prd dbcred file
    $prdpbwpruckus=decrypt("VKzcYHZbV719UxEBMw12SA==")
    file { "/app/shared/wordpress/dbcred/ruckus_database.inc.php":
         content => template('atomiconline/prd_ruckus_database.inc.php'),
         }

#### Create hockeysfuture.com prd dbcred file
    $prdpbwphockeysfuturerw=decrypt("o5JN93CTGl2FAwGkhbwWjw==")
    $prdpbwphockeysfuturero=decrypt("HiLW/FosFifLVG7GhlbDGw==")
    file { "/app/shared/wordpress/dbcred/db_hockeysfuture.com.php":
         content => template('atomiconline/prd_db_hockeysfuture.com.php'),
         }

#### Create pbwp.gnmedia.net prd dbcred file
    $prdpbwpgnmediarw=decrypt("HsOOI0MJRRdjoZLtc5qctA==")
    $prdpbwpgnmediaro=decrypt("UBpHbAacG3PLfq72LoEKrA==")
    file { "/app/shared/wordpress/dbcred/db_pbwp.gnmedia.net.php":
         content => template('atomiconline/prd_db_pbwp.gnmedia.net.php'),
         }

#### Create playstationlifestyle.net prd dbcred file
    $prdpbwpplaystationlifestylerw=decrypt("t9VcwBZ6ldCuRGQ2YLDsmQ==")
    $prdpbwpplaystationlifestylero=decrypt("KdutJ0fbffgbOHUuYQd9Sg==")
    file { "/app/shared/wordpress/dbcred/db_playstationlifestyle.net.php":
         content => template('atomiconline/prd_db_playstationlifestyle.net.php'),
         }

#### Create realitytea.com prd dbcred file
  $prdpbwprealitytearw=decrypt("4ZQWHhjV6zDHA1LpdtpeBw==")
  $prdpbwprealitytearo=decrypt("m0DO6HuZieQPqAro0Ybjdw==")
    file { "/app/shared/wordpress/dbcred/db_realitytea.com.php":
         content => template('atomiconline/prd_db_realitytea.com.php'),
         }

#### Create craveonline.com prd dbcred file
  $prdpbwp_craveonlinero=decrypt("r2FakzBiAbdXg3wvmVAfaw==")
  $prdpbwp_craveonlinerw=decrypt("D02CDokj6n7y//50lTH7vA==")
    file { "/app/shared/wordpress/dbcred/db_craveonline.com.php":
         content => template('atomiconline/prd_db_craveonline.com.php'),
         }

#### Create thefashionspot.com prd dbcred file
  $prdpbwp_thefashionspotro=decrypt("uh0HDpVe+ReNCIyiEeZvxw==")
  $prdpbwp_thefashionspotrw=decrypt("7bBgGb1cMO0mYBuSCKusYQ==")
    file { "/app/shared/wordpress/dbcred/db_thefashionspot.com.php":
         content => template('atomiconline/prd_db_thefashionspot.com.php'),
         }

#### Create idly.craveonline.com prd dbcred file
  $prdpbwp_idlyitwro=decrypt("lTSp/3g+37+opAKRQst1HQ==")
  $prdpbwp_idlyitwrw=decrypt("z6Kykpv1DoCnU84ZTLQZsQ==")
    file { "/app/shared/wordpress/dbcred/db_idly.craveonline.com.php":
         content => template('atomiconline/prd_db_idly.craveonline.com.php'),
         }

#prdtoken

#### Create mandatory.com prd dbcred file
  $prdpbwp_mandatoryro=decrypt("0neW0HLuGHgBUmbSpFovFw==")
  $prdpbwp_mandatoryrw=decrypt("+g0529B7R6G5HWjF3drT4g==")
    file { "/app/shared/wordpress/dbcred/db_mandatory.com.php":
         content => template('atomiconline/prd_db_mandatory.com.php'),
         }


#### Create awards.totalbeauty.com prd dbcred file
  $prdpbwp_awards_totalbeautyro=decrypt("+P5N9tpWWbU/rj1NFoK86w==")
  $prdpbwp_awards_totalbeautyrw=decrypt("r6TYtvfzeundks5+tlk36g==")
    file { "/app/shared/wordpress/dbcred/db_awards.totalbeauty.com.php":
         content => template('atomiconline/prd_db_awards.totalbeauty.com.php'),
         }


#### Create ropeofsilicon.com prd dbcred file
  $prdpbwp_ropeofsiliconro=decrypt("fVoJpz9Ib6llpv0f8xaBYw==")
  $prdpbwp_ropeofsiliconrw=decrypt("OzGghfCSdy6ZcKCjDC/8MA==")
    file { "/app/shared/wordpress/dbcred/db_ropeofsilicon.com.php":
         content => template('atomiconline/prd_db_ropeofsilicon.com.php'),
         }

#### Create dogtime.com prd dbcred file
  $prdpbwp_dogtimero=decrypt("ZXtVjYtjebUdOx3/NMY2ow==")
  $prdpbwp_dogtimerw=decrypt("38UY5Qrt+n97GoBsrBOHhQ==")
    file { "/app/shared/wordpress/dbcred/db_dogtime.com.php":
         content => template('atomiconline/prd_db_dogtime.com.php'),
         }

#### Create base.evolvemediallc.com prd dbcred file
  $prdpbwp_basero=decrypt("7y7KDHwmC2gM/pZk27dyaw==")
  $prdpbwp_baserw=decrypt("3KEdpsKzfiS6AfzQR8pjMg==")
    file { "/app/shared/wordpress/dbcred/db_base.evolvemediallc.com.php":
         content => template('atomiconline/prd_db_base.evolvemediallc.com.php'),
         }

#### Create musicfeeds.com.au prd dbcred file
  $prdpbwp_musicfeedsro=decrypt("OToQ3i398rQQqaBulOOrbg==")
  $prdpbwp_musicfeedsrw=decrypt("nbx4PVpoAoJTPwUn2Vvwdw==")
    file { "/app/shared/wordpress/dbcred/db_musicfeeds.com.au.php":
         content => template('atomiconline/prd_db_musicfeeds.com.au.php'),
         }

#### Create cattime.com prd dbcred file
  $prdpbwp_cattimero=decrypt("rgPrqUpL+JecZFGDTYn4Ig==")
  $prdpbwp_cattimerw=decrypt("n6JcoWTQFTxpxE+jv/Ky6w==")
    file { "/app/shared/wordpress/dbcred/db_cattime.com.php":
         content => template('atomiconline/prd_db_cattime.com.php'),
         }

#### Create beautyriot.com prd dbcred file
  $prdpbwp_beautyriotro=decrypt("yhwQpoVo4l4C+sx8U1XENA==")
  $prdpbwp_beautyriotrw=decrypt("/NWz9RAOMLPr8SqdP98x7g==")
    file { "/app/shared/wordpress/dbcred/db_beautyriot.com.php":
         content => template('atomiconline/prd_db_beautyriot.com.php'),
         }

#### Create evolvemediallc.com prd dbcred file
  $prdpbwp_evolvemediallcro=decrypt("XYgrpHzajwsSI3DWVloP6w==")
  $prdpbwp_evolvemediallcrw=decrypt("Z3KXQi4P+w78Gq2yD0MvwQ==")
    file { "/app/shared/wordpress/dbcred/db_evolvemediallc.com.php":
         content => template('atomiconline/prd_db_evolvemediallc.com.php'),
         }

#### Create totallykidz.com prd dbcred file
  $prdpbwp_totallykidzro=decrypt("RKaVaqKMiD9Y+h0Jyrgf/Q==")
  $prdpbwp_totallykidzrw=decrypt("XHu9Eb6LeeKdD3g6dr/hNQ==")
    file { "/app/shared/wordpress/dbcred/db_totallykidz.com.php":
         content => template('atomiconline/prd_db_totallykidz.com.php'),
         }

#### Create afterellen.com prd dbcred file
  $prdpbwp_afterellenro=decrypt("/xOVxJtB1NUw+NK8wut9FA==")
  $prdpbwp_afterellenrw=decrypt("nTSXWM17ibx3ZOOGGGpg0A==")
    file { "/app/shared/wordpress/dbcred/db_afterellen.com.php":
         content => template('atomiconline/prd_db_afterellen.com.php'),
         }

#### Create home.springboardplatform.com prd dbcred file
  $prdpbwp_springboardro=decrypt("8gucHg9SfZv8sIR+xLR8jw==")
  $prdpbwp_springboardrw=decrypt("ajqLy934mEbOdPS9CTcHKQ==")
    file { "/app/shared/wordpress/dbcred/db_home.springboardplatform.com.php":
         content => template('atomiconline/prd_db_home.springboardplatform.com.php'),
         }

#### Create totallyhermedia.com prd dbcred file
  $prdpbwp_totallyhermediaro=decrypt("JdTlAkR3ClRq6b7sZaJvDg==")
  $prdpbwp_totallyhermediarw=decrypt("HQ4ljWbegL+YSyF6z92kGQ==")
    file { "/app/shared/wordpress/dbcred/db_totallyhermedia.com.php":
         content => template('atomiconline/prd_db_totallyhermedia.com.php'),
         }

#### Create craveonlinemedia.com prd dbcred file
  $prdpbwp_craveonlinemediaro=decrypt("eLwAr3Qn/IAYBe0Th0/sjA==")
  $prdpbwp_craveonlinemediarw=decrypt("s7fOvP7ozPwqX3FEEz9NuQ==")
    file { "/app/shared/wordpress/dbcred/db_craveonlinemedia.com.php":
         content => template('atomiconline/prd_db_craveonlinemedia.com.php'),
         }

#### Create webecoist.momtastic.com prd dbcred file
  $prdpbwp_webecoistro=decrypt("O5mpS8k6gcXYrOpDbpoXwQ==")
  $prdpbwp_webecoistrw=decrypt("wuj0sRCxwMiLuuaz9ec7GQ==")
    file { "/app/shared/wordpress/dbcred/db_webecoist.momtastic.com.php":
         content => template('atomiconline/prd_db_webecoist.momtastic.com.php'),
         }

#### Create comingsoon.net prd dbcred file
  $prdpbwp_comingsoonro=decrypt("/V9GLFw+8uxQ1yVMo6yGvA==")
  $prdpbwp_comingsoonrw=decrypt("06OfzD3w9uiiJzBAa/GYzg==")
    file { "/app/shared/wordpress/dbcred/db_comingsoon.net.php":
         content => template('atomiconline/prd_db_comingsoon.net.php'),
         }

#### Create ringtv.craveonline.com prd dbcred file
  $prdpbwp_ringtvro=decrypt("Lqq1yXx2rDklUQJMVXYCag==")
  $prdpbwp_ringtvrw=decrypt("8Q1dUCXvZOolPcoaBULlrA==")
    file { "/app/shared/wordpress/dbcred/db_ringtv.craveonline.com.php":
         content => template('atomiconline/prd_db_ringtv.craveonline.com.php'),
         }

#### Create superherohype.com prd dbcred file
  $prdpbwp_superherohypero=decrypt("hn/+dmEcrrrYap00O0aQaw==")
  $prdpbwp_superherohyperw=decrypt("TcV102s471wXM12/mZh3Ag==")
    file { "/app/shared/wordpress/dbcred/db_superherohype.com.php":
         content => template('atomiconline/prd_db_superherohype.com.php'),
         }

#### Create shocktillyoudrop.com prd dbcred file
  $prdpbwp_shocktillyoudropro=decrypt("LbBXxPtWkaWKVM+VkBYWOg==")
  $prdpbwp_shocktillyoudroprw=decrypt("+k7OWyCAbzhdoRUPz7HJBg==")
    file { "/app/shared/wordpress/dbcred/db_shocktillyoudrop.com.php":
         content => template('atomiconline/prd_db_shocktillyoudrop.com.php'),
         }

#### Create momtastic.com prd dbcred file
  $prdpbwp_momtasticro=decrypt("zvcvJc8+kSPxCwwnhwBs6Q==")
  $prdpbwp_momtasticrw=decrypt("HGVmck+mKC0f2SusRO0m4g==")
    file { "/app/shared/wordpress/dbcred/db_momtastic.com.php":
         content => template('atomiconline/prd_db_momtastic.com.php'),
         }

#### Create mumtasticuk.co.uk prd dbcred file
  $prdpbwp_mumtasticukro=decrypt("HuzC1WENhaaqBEVvGyfPdA==")
  $prdpbwp_mumtasticukrw=decrypt("/ijGKfWBBjU1vhepEGAiQA==")
    file { "/app/shared/wordpress/dbcred/db_mumtasticuk.co.uk.php":
         content => template('atomiconline/prd_db_mumtasticuk.co.uk.php'),
         }

#### Create momtastic.com.au prd dbcred file
  $prdpbwp_momtasticauro=decrypt("H3VvL9GW6vg7SmBzppc9zg==")
  $prdpbwp_momtasticaurw=decrypt("FhA9hVtAcgWtdgXSqqCDsA==")
    file { "/app/shared/wordpress/dbcred/db_momtastic.com.au.php":
         content => template('atomiconline/prd_db_momtastic.com.au.php'),
         }

#### Create wrestlezone.com prd dbcred file
  $prdpbwp_wrestlezonero=decrypt("6pvaI4LD7U9HZW/GhYS9aw==")
  $prdpbwp_wrestlezonerw=decrypt("PIhYUItP22Qjdal2CrFHjg==")
    file { "/app/shared/wordpress/dbcred/db_wrestlezone.com.php":
         content => template('atomiconline/prd_db_wrestlezone.com.php'),
         }

#### Create liveoutdoors.com prd dbcred file
  $prdpbwp_liveoutdoorsro=decrypt("NtN59Y27ULfpcskYhH9Xnw==")
  $prdpbwp_liveoutdoorsrw=decrypt("vxrEg9EOeYzGhH4/4BTJwg==")
    file { "/app/shared/wordpress/dbcred/db_liveoutdoors.com.php":
         content => template('atomiconline/prd_db_liveoutdoors.com.php'),
         }

#### Create hoopsvibe.com prd dbcred file
  $prdpbwp_hoopsvibero=decrypt("cH53+D/rGnY/M1yQU6xp1w==")
  $prdpbwp_hoopsviberw=decrypt("1QgKDuiwb2kthx61tvuy0Q==")
    file { "/app/shared/wordpress/dbcred/db_hoopsvibe.com.php":
         content => template('atomiconline/prd_db_hoopsvibe.com.php'),
         }

#### Create wholesomebabyfood.momtastic.com prd dbcred file
  $prdpbwp_wholesomebabyfoodro=decrypt("+U7YH7z9NA8y5xa6qaioVA==")
  $prdpbwp_wholesomebabyfoodrw=decrypt("Ak6CsK+Kovc16UQyiXsUqQ==")
    file { "/app/shared/wordpress/dbcred/db_wholesomebabyfood.momtastic.com.php":
         content => template('atomiconline/prd_db_wholesomebabyfood.momtastic.com.php'),
         }

#### Create totallyher.com prd dbcred file
  $prdpbwp_totallyherro=decrypt("QTKK/4LIAt4PxrC0lnOS1w==")
  $prdpbwp_totallyherrw=decrypt("uC5O0eqt3A+57m+xvHzKlA==")
    file { "/app/shared/wordpress/dbcred/db_totallyher.com.php":
         content => template('atomiconline/prd_db_totallyher.com.php'),
         }

#### Create bufferzone.craveonline.com prd dbcred file
  $prdpbwp_bufferzonero=decrypt("HUg8KCMGT4LAOWLhI1twqw==")
  $prdpbwp_bufferzonerw=decrypt("5B9y1OsrtI8rYrh7hECmXg==")
    file { "/app/shared/wordpress/dbcred/db_bufferzone.craveonline.com.php":
         content => template('atomiconline/prd_db_bufferzone.craveonline.com.php'),
         }


}
