node 'app1v-wpbeta.ao.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base

    $project='atomiconline'
    $httpd='pbwordpressbeta'


############################################################################
##### Packages to be installed #############################################
############################################################################

    include common::app
    include httpd
    include mysqld56::client
    include subversion::client
    include rubygems::compass
    include rubygems::susy
    include rubygems::livereload
    include net_snmp
    include util::vim
    include memcached
    class { 'php::install': ini_template => 'atomiconline/php.ini-pbwp.erb', extra_packages => ['php-pecl-xdebug', 'php-pecl-apc'] }

    #### Yum Packages
    package {'ant': ensure => installed,}
    package {'git-svn': ensure => installed,}
    package {'gcc-c++': ensure => installed,}
    package {'ruby-devel': ensure => installed,}
    package {'ant-apache-regexp': ensure => installed,}
    package {'php-channel-phpunit': ensure => installed,}
    package {'php-phpunit-PHPUnit': ensure => installed,}
    package {'php-pear': ensure => installed,}


############################################################################
##### VHOSTS ###############################################################
############################################################################

    httpd::pbwordpress_beta_vhost {'afterellen.com':                     expect => 'false',                     }
    httpd::pbwordpress_beta_vhost {'base.evolvemediallc.com':            expect => 'false',                     }
    httpd::pbwordpress_beta_vhost {'musicfeeds.com.au':                  expect => 'false',                     }
    httpd::pbwordpress_beta_vhost {'cattime.com':                        expect => 'false',                     }
    httpd::pbwordpress_beta_vhost {'dogtime.com':                        expect => 'false',                     }
    httpd::pbwordpress_beta_vhost {'beautyriot.com':                     expect => 'false', needextra => "true",}
    httpd::pbwordpress_beta_vhost {'craveonline.com':                    expect => 'false', needextra => 'true',}
    httpd::pbwordpress_beta_vhost {'craveonline.ca':                     expect => 'false',                     }
    httpd::pbwordpress_beta_vhost {'craveonline.com.au':                 expect => 'false',                     }
    httpd::pbwordpress_beta_vhost {'craveonline.co.uk':                  expect => 'false',                     }
    httpd::pbwordpress_beta_vhost {'craveonlinemedia.com':               expect => 'false',                     }
    httpd::pbwordpress_beta_vhost {'evolvemediallc.com':                 expect => 'false',                     }
    httpd::pbwordpress_beta_vhost {'hockeysfuture.com':                  expect => 'false', needextra => 'true',}
    httpd::pbwordpress_beta_vhost {'idly.craveonline.com':               expect => 'false',                     }
    httpd::pbwordpress_beta_vhost {'pbwp.gnmedia.net':                   expect => 'false',                     }
    httpd::pbwordpress_beta_vhost {'playstationlifestyle.com':           expect => 'false',                     }
    httpd::pbwordpress_beta_vhost {'playstationlifestyle.net':           expect => 'false', needextra => 'true',}
    httpd::pbwordpress_beta_vhost {'realitytea.com':                     expect => 'false', needextra => 'true',}
    httpd::pbwordpress_beta_vhost {'bufferzone.craveonline.com':         expect => 'false', needextra => 'true',}
    httpd::pbwordpress_beta_vhost {'thefashionspot.com':                 expect => 'false', needextra => 'true',}
    httpd::pbwordpress_beta_vhost {'thefashionspot.ca':                  expect => 'false',                     }
    httpd::pbwordpress_beta_vhost {'thefashionspot.com.au':              expect => 'false',                     }
    httpd::pbwordpress_beta_vhost {'totallyher.com':                     expect => 'false', needextra => 'true',}
    httpd::pbwordpress_beta_vhost {'totallyhermedia.com':                expect => 'false', needextra => 'true',}
    httpd::pbwordpress_beta_vhost {'totallykidz.com':                    expect => 'false',                     }
    httpd::pbwordpress_beta_vhost {'mumtasticuk.co.uk':                  expect => 'false',                     }
    httpd::pbwordpress_beta_vhost {'au.momtastic.com':                   expect => 'false',                     }
    httpd::pbwordpress_beta_vhost {'ca.momtastic.com':                   expect => 'false',                     }
    httpd::pbwordpress_beta_vhost {'uk.momtastic.com':                   expect => 'false',                     }
    httpd::pbwordpress_beta_vhost {'momtastic.com.au':                   expect => 'false',                     }
    httpd::pbwordpress_beta_vhost {'momtastic.com':                      expect => 'false', needextra => 'true',}
    httpd::pbwordpress_beta_vhost {'wholesomebabyfood.momtastic.com':    expect => 'false', needextra => "true",}
    httpd::pbwordpress_beta_vhost {'webecoist.momtastic.com':            expect => 'false',                     }
    httpd::pbwordpress_beta_vhost {'hoopsvibe.com':                      expect => 'false', needextra => 'true',}
    httpd::pbwordpress_beta_vhost {'home.springboardplatform.com':       expect => 'false', needextra => "true",}
    httpd::pbwordpress_beta_vhost {'liveoutdoors.com':                   expect => 'false', needextra => 'true',}
    httpd::pbwordpress_beta_vhost {'wrestlezone.com':                    expect => 'false', needextra => 'true',}
    httpd::pbwordpress_beta_vhost {'shocktillyoudrop.com':               expect => 'false', needextra => 'true',}
    httpd::pbwordpress_beta_vhost {'superherohype.com':                  expect => 'false', needextra => 'true',}
    httpd::pbwordpress_beta_vhost {'ringtv.craveonline.com':             expect => 'false', needextra => 'true',}
    httpd::pbwordpress_beta_vhost {'comingsoon.net':                     expect => 'false',                     }
    httpd::pbwordpress_beta_vhost {'ropeofsilicon.net':                  expect => 'false',                     }
    


############################################################################
##### Set up the app server directory structure ############################
############################################################################

    file { ['/app/shared/wordpress',
            '/app/shared/wordpress/dbcred',
            '/app/shared/wordpress/releases']:
            ensure  => directory,
            owner   => 'deploy',
            group   => 'deploy',
            mode    => '0755',
            require => Mount['/app/shared'],
    }

    file { '/var/www/html':
            ensure  => directory,
            owner   => 'deploy',
            group   => 'deploy',
            mode    => '0755',
    }


############################################################################
##### Mount the Volumes ####################################################
############################################################################

    common::nfsmount { '/app/shared':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_shared/wpbeta-shared',
    }

    common::nfsmount { '/app/log':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_log/app1v-wpbeta.ao.dev.lax.gnmedia.net',
    }

    common::ugcmount { '/app/ugc':
        device => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_shared/wp-ugc',
    }



############################################################################
##### APC Configuration ####################################################
############################################################################

    file {'/etc/php.d/apc.ini':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/php/pbwp_apc.ini',
        require => Package['php-pecl-apc'],
        }


############################################################################
##### Pebblebed Wordpress Beta Database Credentials ########################
############################################################################

#### Create ruckus bta dbcred file
    $btapbwpruckus=decrypt('tYAj2SKMvzPA7MA//ldZzg==')
    file { '/app/shared/wordpress/dbcred/ruckus_database.inc.php':
        ensure  => file,
        content => template('atomiconline/bta_ruckus_database.inc.php'),
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }

#### Create hockeysfuture.com bta dbcred file
    $btapbwphockeysfuturerw=decrypt('56KQTtpZbCu0W0wNS4uudA==')
    $btapbwphockeysfuturero=decrypt('CopEW/Az30OZECGNeDQUCA==')
    file { '/app/shared/wordpress/dbcred/db_hockeysfuture.com.php':
        ensure  => file,
        content => template('atomiconline/bta_db_hockeysfuture.com.php'),
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }

#### Create pbwp.gnmedia.net bta dbcred file
    $btapbwpgnmediarw=decrypt('G1tjVUGaa0ptaiQjkEjoPA==')
    $btapbwpgnmediaro=decrypt('OkJJUcs9VxrpMihA0vm2nA==')
    file { '/app/shared/wordpress/dbcred/db_pbwp.gnmedia.net.php':
        ensure  => file,
        content => template('atomiconline/bta_db_pbwp.gnmedia.net.php'),
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }

#### Create playstationlifestyle.net bta dbcred file
    $btapbwpplaystationlifestylerw=decrypt('+xcTTMSqh1dbH71pDtFmtw==')
    $btapbwpplaystationlifestylero=decrypt('ri7WLzCAQZ8+jMJ7/Q15OQ==')
    file { '/app/shared/wordpress/dbcred/db_playstationlifestyle.net.php':
        ensure  => file,
        content => template('atomiconline/bta_db_playstationlifestyle.net.php'),
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }

#### Create realitytea.com bta dbcred file
    $btapbwprealitytearw=decrypt('CKXi4DCThHoh2BQTJYcPJA==')
    $btapbwprealitytearo=decrypt('3bvzQ+7uQCjekYkr9wf45g==')
    file { '/app/shared/wordpress/dbcred/db_realitytea.com.php':
        ensure  => file,
        content => template('atomiconline/bta_db_realitytea.com.php'),
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }

#### Create craveonline.com bta dbcred file
    $btapbwp_craveonlinero=decrypt('O8gVrgUXkiT47T8mR5+G6w==')
    $btapbwp_craveonlinerw=decrypt('I4y6C7Gs0WoTIldFhryeRg==')
    file { '/app/shared/wordpress/dbcred/db_craveonline.com.php':
        ensure  => file,
        content => template('atomiconline/bta_db_craveonline.com.php'),
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }

#### Create thefashionspot.com bta dbcred file
    $btapbwp_thefashionspotro=decrypt('cJyIZnXL8eU5Ach93daycw==')
    $btapbwp_thefashionspotrw=decrypt('vsetyp6SU7B1T/6BNuAiVA==')
    file { '/app/shared/wordpress/dbcred/db_thefashionspot.com.php':
        ensure  => file,
        content => template('atomiconline/bta_db_thefashionspot.com.php'),
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }

#### Create idly.craveonline.com bta dbcred file
    $btapbwp_idlyitwro=decrypt('YhjOD3PLJds6TJRZpvFK1Q==')
    $btapbwp_idlyitwrw=decrypt('OIDKQ4IeB2C3suUMPiIdvw==')
    file { '/app/shared/wordpress/dbcred/db_idly.craveonline.com.php':
        ensure  => file,
        content => template('atomiconline/bta_db_idly.craveonline.com.php'),
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }

#btatoken

#### Create mandatory.com bta dbcred file
  $btapbwp_mandatoryro=decrypt("rzOw619jONLr7rzT+2xAeA==")
  $btapbwp_mandatoryrw=decrypt("Z/D7Phg6cmR6lOJiSCCc2w==")
    file { "/app/shared/wordpress/dbcred/db_mandatory.com.php":
         content => template('atomiconline/bta_db_mandatory.com.php'),
         }

#### Create awards.totalbeauty.com bta dbcred file
  $btapbwp_awards_totalbeautyro=decrypt("ikZR2RvTsVU9y8DlMtqEtA==")
  $btapbwp_awards_totalbeautyrw=decrypt("lmgjPx+hgBnw2goiGAZvEg==")
    file { "/app/shared/wordpress/dbcred/db_awards.totalbeauty.com.php":
         content => template('atomiconline/bta_db_awards.totalbeauty.com.php'),
         }

#### Create ropeofsilicon.com bta dbcred file
  $btapbwp_ropeofsiliconro=decrypt("rmLXeLDEywPmF92R3AeZ1g==")
  $btapbwp_ropeofsiliconrw=decrypt("OSpxi/I/t5VR+vpieocnWw==")
    file { "/app/shared/wordpress/dbcred/db_ropeofsilicon.com.php":
         content => template('atomiconline/bta_db_ropeofsilicon.com.php'),
         }

#### Create dogtime.com bta dbcred file
  $btapbwp_dogtimero=decrypt("bBcEeRfNLPEQvEIahLAnaw==")
  $btapbwp_dogtimerw=decrypt("algu1Jrx+/8iyO5BBUEdfA==")
    file { "/app/shared/wordpress/dbcred/db_dogtime.com.php":
         content => template('atomiconline/bta_db_dogtime.com.php'),
         }

#### Create base.evolvemediallc.com bta dbcred file
  $btapbwp_basero=decrypt("HUTt02gR3vF91Gen4eFVyA==")
  $btapbwp_baserw=decrypt("MJpq4n1QLsM63zuBMjjGHg==")
    file { "/app/shared/wordpress/dbcred/db_base.evolvemediallc.com.php":
         content => template('atomiconline/bta_db_base.evolvemediallc.com.php'),
         }

#### Create musicfeeds.com.au bta dbcred file
  $btapbwp_musicfeedsro=decrypt("5tOmWs4+3pKmQPOpFDdiUQ==")
  $btapbwp_musicfeedsrw=decrypt("tiVi5k+7QZDn4KCE+oRDrw==")
    file { "/app/shared/wordpress/dbcred/db_musicfeeds.com.au.php":
         content => template('atomiconline/bta_db_musicfeeds.com.au.php'),
         }

#### Create cattime.com bta dbcred file
  $btapbwp_cattimero=decrypt("U6ZR/6NB6WEK2FygDm1sQQ==")
  $btapbwp_cattimerw=decrypt("7XZCRK5LW+Gtfh+Mnj/8+g==")
    file { "/app/shared/wordpress/dbcred/db_cattime.com.php":
         content => template('atomiconline/bta_db_cattime.com.php'),
         }

#### Create afterellen.com bta dbcred file
  $btapbwp_afterellenro=decrypt("Ra3B3d5GlAejpKZW6ywn2w==")
  $btapbwp_afterellenrw=decrypt("qtXynJi6UNhgTRzNnKtiUg==")
    file { "/app/shared/wordpress/dbcred/db_afterellen.com.php":
         content => template('atomiconline/bta_db_afterellen.com.php'),
         }

#### Create beautyriot.com bta dbcred file
  $btapbwp_beautyriotro=decrypt("X+m0PuWLDziY+6xx5K84OQ==")
  $btapbwp_beautyriotrw=decrypt("hvDQt1EOeeWsgqXHNTJ+0Q==")
    file { "/app/shared/wordpress/dbcred/db_beautyriot.com.php":
         content => template('atomiconline/bta_db_beautyriot.com.php'),
         }

#### Create evolvemediallc.com bta dbcred file
  $btapbwp_evolvemediallcro=decrypt("qyC6JbBsTMgAFU+akKk8Xg==")
  $btapbwp_evolvemediallcrw=decrypt("RqfZV4hruBsV9hRx+oKSgQ==")
    file { "/app/shared/wordpress/dbcred/db_evolvemediallc.com.php":
         content => template('atomiconline/bta_db_evolvemediallc.com.php'),
         }

#### Create home.springboardplatform.com bta dbcred file
    $btapbwp_springboardro=decrypt('VoFeWRhvi3p8qQUnnJYGvw==')
    $btapbwp_springboardrw=decrypt('DIbEz06eSMk8Jm3Y0JN1jQ==')
    file { '/app/shared/wordpress/dbcred/db_home.springboardplatform.com.php':
        ensure  => file,
        content => template('atomiconline/bta_db_home.springboardplatform.com.php'),
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }

#### Create totallyhermedia.com bta dbcred file
    $btapbwp_totallyhermediaro=decrypt('LXV513Cn5wMJGyAgxxwfzQ==')
    $btapbwp_totallyhermediarw=decrypt('aBuBC63XG0TG9n8w6XU6Vw==')
    file { '/app/shared/wordpress/dbcred/db_totallyhermedia.com.php':
        ensure  => file,
        content => template('atomiconline/bta_db_totallyhermedia.com.php'),
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }

#### Create craveonlinemedia.com bta dbcred file
    $btapbwp_craveonlinemediaro=decrypt('Lo5+3hYM6u+DCqXoKPwkwA==')
    $btapbwp_craveonlinemediarw=decrypt('B+hPdDQWqiQHXWq/sZ8gpg==')
    file { '/app/shared/wordpress/dbcred/db_craveonlinemedia.com.php':
        ensure  => file,
        content => template('atomiconline/bta_db_craveonlinemedia.com.php'),
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }

#### Create webecoist.momtastic.com bta dbcred file
    $btapbwp_webecoistro=decrypt('8dyCHVWYqcO6qev01QEUIw==')
    $btapbwp_webecoistrw=decrypt('lbiLS14xR5Owr5i/5PAAhg==')
    file { '/app/shared/wordpress/dbcred/db_webecoist.momtastic.com.php':
        ensure  => file,
        content => template('atomiconline/bta_db_webecoist.momtastic.com.php'),
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }

#### Create comingsoon.net bta dbcred file
    $btapbwp_comingsoonro=decrypt('0Kuii+MjXfBRdgZIkSo6hg==')
    $btapbwp_comingsoonrw=decrypt('wyzIyMMpQ41waNxbcVUrJQ==')
    file { '/app/shared/wordpress/dbcred/db_comingsoon.net.php':
        ensure  => file,
        content => template('atomiconline/bta_db_comingsoon.net.php'),
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }

#### Create ringtv.craveonline.com bta dbcred file
    $btapbwp_ringtvro=decrypt('mXFghNVkGZa3adXtDqbYfQ==')
    $btapbwp_ringtvrw=decrypt('Md9NvMNE6EdXG+qEJTEQcQ==')
    file { '/app/shared/wordpress/dbcred/db_ringtv.craveonline.com.php':
        ensure  => file,
        content => template('atomiconline/bta_db_ringtv.craveonline.com.php'),
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }

#### Create superherohype.com bta dbcred file
    $btapbwp_superherohypero=decrypt('1AMHL1wI0p3a/rRiCk8ovw==')
    $btapbwp_superherohyperw=decrypt('4Q1KxlJca2TjuwATJa4dTg==')
    file { '/app/shared/wordpress/dbcred/db_superherohype.com.php':
        ensure  => file,
        content => template('atomiconline/bta_db_superherohype.com.php'),
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }

#### Create shocktillyoudrop.com bta dbcred file
    $btapbwp_shocktillyoudropro=decrypt('CeVggWlUzU050Mlmuk8bUQ==')
    $btapbwp_shocktillyoudroprw=decrypt('aYsGQiI7KMt4U08NZlj6oQ==')
    file { '/app/shared/wordpress/dbcred/db_shocktillyoudrop.com.php':
        ensure  => file,
        content => template('atomiconline/bta_db_shocktillyoudrop.com.php'),
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }

#### Create momtastic.com bta dbcred file
    $btapbwp_momtasticro=decrypt('KzAJkPchIu5oK8UALOb1bA==')
    $btapbwp_momtasticrw=decrypt('HvlsQDVYGgY6hv88+aGRSw==')
    file { '/app/shared/wordpress/dbcred/db_momtastic.com.php':
        ensure  => file,
        content => template('atomiconline/bta_db_momtastic.com.php'),
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }

#### Create mumtasticuk.co.uk bta dbcred file
    $btapbwp_mumtasticukro=decrypt('FCqRCWsGDFxmxyFu17bYUA==')
    $btapbwp_mumtasticukrw=decrypt('qXZiQC//nKDtNr38iMWtAA==')
    file { '/app/shared/wordpress/dbcred/db_mumtasticuk.co.uk.php':
        ensure  => file,
        content => template('atomiconline/bta_db_mumtasticuk.co.uk.php'),
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }

#### Create momtastic.com.au bta dbcred file
    $btapbwp_momtasticauro=decrypt('69QvR+k5WHYNv6ff8rIMvg==')
    $btapbwp_momtasticaurw=decrypt('P1J2Zkq5mLbf0ZB66HTDOg==')
    file { '/app/shared/wordpress/dbcred/db_momtastic.com.au.php':
        ensure  => file,
        content => template('atomiconline/bta_db_momtastic.com.au.php'),
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }

#### Create wrestlezone.com bta dbcred file
    $btapbwp_wrestlezonero=decrypt('hNIKgLry2JIs+jFGHKUHbg==')
    $btapbwp_wrestlezonerw=decrypt('Jzul/qPuD+6FZXF66CnnqQ==')
    file { '/app/shared/wordpress/dbcred/db_wrestlezone.com.php':
        ensure  => file,
        content => template('atomiconline/bta_db_wrestlezone.com.php'),
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }

#### Create liveoutdoors.com bta dbcred file
    $btapbwp_liveoutdoorsro=decrypt('ExYvKcfLhe4/06aOGit80g==')
    $btapbwp_liveoutdoorsrw=decrypt('wGNM8K6GmnONshLZH/1CXA==')
    file { '/app/shared/wordpress/dbcred/db_liveoutdoors.com.php':
        ensure  => file,
        content => template('atomiconline/bta_db_liveoutdoors.com.php'),
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }

#### Create hoopsvibe.com bta dbcred file
    $btapbwp_hoopsvibero=decrypt('7Fn1qaRKs5L7ioIcir9RDA==')
    $btapbwp_hoopsviberw=decrypt('3IaT7FzDapl9zMNSdGiyXw==')
    file { '/app/shared/wordpress/dbcred/db_hoopsvibe.com.php':
        ensure  => file,
        content => template('atomiconline/bta_db_hoopsvibe.com.php'),
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }

#### Create wholesomebabyfood.momtastic.com bta dbcred file
    $btapbwp_wholesomebabyfoodro=decrypt('xT54gJlNx8qAyWrNzeaL5w==')
    $btapbwp_wholesomebabyfoodrw=decrypt('zJfstfEYkGPXMMrtqrsoWA==')
    file { '/app/shared/wordpress/dbcred/db_wholesomebabyfood.momtastic.com.php':
        ensure  => file,
        content => template('atomiconline/bta_db_wholesomebabyfood.momtastic.com.php'),
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }

#### Create totallyher.com bta dbcred file
    $btapbwp_totallyherro=decrypt('zvthGAZchHShN6t24R5i2A==')
    $btapbwp_totallyherrw=decrypt('FpVeSN6Rgq8AJAIrSzK1Kg==')
    file { '/app/shared/wordpress/dbcred/db_totallyher.com.php':
        ensure  => file,
        content => template('atomiconline/bta_db_totallyher.com.php'),
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }

#### Create bufferzone.craveonline.com bta dbcred file
    $btapbwp_bufferzonero=decrypt('ijAIUL3sLX10oHPNK3A1Bw==')
    $btapbwp_bufferzonerw=decrypt('La38SAl39XcEYdjk970eJQ==')
    file { '/app/shared/wordpress/dbcred/db_bufferzone.craveonline.com.php':
        ensure  => file,
        content => template('atomiconline/bta_db_bufferzone.craveonline.com.php'),
        owner   => 'deploy',
        group   => 'deploy',
        mode    => '0644',
    }

#### Create studio.musicfeeds.com.au bta dbcred file
  $btapbwp_studio_musicfeedsro=decrypt("t2uwb+pT2QLQwmawu96WKg==")
  $btapbwp_studio_musicfeedsrw=decrypt("4G1Az2JRlJAKfx8Skfggrg==")
    file { "/app/shared/wordpress/dbcred/db_studio.musicfeeds.com.au.php":
         content => template('atomiconline/bta_db_studio.musicfeeds.com.au.php'),
         }


}
