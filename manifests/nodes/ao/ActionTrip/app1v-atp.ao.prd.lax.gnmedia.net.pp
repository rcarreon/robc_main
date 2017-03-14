node 'app1v-atp.ao.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="atomiconline"
        $site="actiontrip"
        $httpd="actiontripc6"
        include subversion::client
        include common::app
        include php::atp
        include php::pecl_imagick
        include httpd
        httpd::virtual_host {"actiontrip.com":}
        httpd::virtual_host {"at-comics.com":}
        httpd::virtual_host {"www.origin.actiontrip.com":}


        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/atp-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app1v-atp.ao.prd.lax.gnmedia.net",
        }

        common::nfsmount { "/app/ugc":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/atp-ugc",
        }

        # Cron scripts for actiontrip.com (migrated over from old server)
        cron { get_news:
            user    => deploy,
            ensure  => present,
            hour    => 4,
            minute  => 26,
            command => "/usr/bin/php -q /app/shared/actiontrip.com/htdocs/atdlcom/public_html/rei/db/get_news_and_more.php"
        }

        cron { get_right_column_tops:
            user    => deploy,
            ensure  => present,
            hour    => 4,
            minute  => 30,
            command => "/usr/bin/php -q /app/shared/actiontrip.com/htdocs/rei/db/get_right_column_tops.php"
        }

        cron { get_most_popular_pages:
            user    => deploy,
            ensure  => present,
            hour    => 5,
            minute  => 26,
            weekday => 7,
            command => "/usr/bin/php -q /app/shared/actiontrip.com/htdocs/rei/db/get_most_popular_pages.php"
        }

        cron { get_video_views:
            user    => deploy,
            ensure  => present,
            hour    => '*/4',
            minute  => 33,
            command => "/usr/bin/php -q /app/shared/actiontrip.com/htdocs/rei/db/get_video_views.php"
        }

        cron { gamerevolution_cheat_links:
            user     => deploy,
            ensure   => present,
            monthday => '*/15',
            hour     => 5,
            minute   => 40,
            command  => "/usr/bin/php -q /app/shared/actiontrip.com/htdocs/rei/db/cheats_links_gamerevolution.php"
        }

        cron { cheatmaster_links:
            user     => deploy,
            ensure   => present,
            monthday => '*/2',
            hour     => 5,
            minute   => 35,
            command  => "/usr/bin/php -q /app/shared/actiontrip.com/htdocs/rei/db/cheats_links_cheatmasters.php"
        }

        cron { 1000waystocheat:
            user     => deploy,
            ensure   => present,
            monthday => '*/2',
            hour     => 5,
            minute   => 38,
            command  => "/usr/bin/php -q /app/shared/actiontrip.com/htdocs/rei/db/cheats_links_1000waystocheat.php"
        }

        cron { cheathappens: 
            user     => deploy,
            ensure   => present,
            monthday => '*/12',
            hour     => 5,
            minute   => 31,
            command  => "/usr/bin/php -q /app/shared/actiontrip.com/htdocs/rei/db/cheats_links_cheathappens.php"
        }

        cron { chaptercheats:
            user     => deploy,
            ensure   => absent,
            monthday => '*/12',
            hour     => 5,
            minute   => 32,
            command  => "/usr/bin/php -q /app/shared/actiontrip.com/htdocs/rei/db/cheats_links_chaptercheats.php"
        }

        cron { cheatingdome:
            user     => deploy,
            ensure   => present,
            monthday => '*/3',
            hour     => 5,
            minute   => 39,
            command  => "/usr/bin/php -q /app/shared/actiontrip.com/htdocs/rei/db/cheats_links_cheatingdome.php"
        }

        cron { gamecheatseu:
            user     => deploy,
            ensure   => present,
            monthday => '*/8',
            hour     => 5,
            minute   => 36,
            command  => "/usr/bin/php -q /app/shared/actiontrip.com/htdocs/rei/db/cheats_links_gamecheatseu.php"
        }

        cron { consolecheatcodes:
            user     => deploy,
            ensure   => present,
            monthday => '*/3',
            hour     => 5,
            minute   => 40,
            command  => "/usr/bin/php -q /app/shared/actiontrip.com/htdocs/rei/db/cheats_links_consolecheatcodes.php"
        }


        cron { cheatsguru:
            user     => deploy,
            ensure   => present,
            hour     => 4,
            minute   => 34,
            command  => "/usr/bin/php -q /app/shared/actiontrip.com/htdocs/rei/db/cheats_links_cheatsguru.php"
        }

        cron { sites_links:
            user     => deploy,
            ensure   => present,
            hour     => 0,
            minute   => 20,
            command  => "/usr/bin/php -q /app/shared/actiontrip.com/htdocs/rei/db/check_other_sites_links.php"
        }

        cron { sites_links2:
            user     => deploy,
            ensure   => present,
            hour     => 0,
            minute   => 22,
            command  => "/usr/bin/php -q /app/shared/actiontrip.com/htdocs/rei/db/check_other_sites_links2.php"
        }

        cron { links_gangaming:
            user     => deploy,
            ensure   => present,
            hour     => 5,
            minute   => 32,
            command  => "/usr/bin/php -q /app/shared/actiontrip.com/htdocs/rei/db/files_links_fangaming.php"
        }


#### Create dbcred file
    file { ['/app/shared/actiontrip.com/dbcred']:
         ensure => directory,
         owner   => deploy,
         group   => deploy,
         mode    => 755,
         require => Mount["/app/shared"],
         }

    $actiontripdevropw=decrypt("mo4r/qqgiooEqWBVGHJrPA==")
    $actiontripdevrwpw=decrypt("mo4r/qqgiooEqWBVGHJrPA==")
    $actiontripstgropw=decrypt("WXLItcPTq7+QzxF66tifqQ==")
    $actiontripstgrwpw=decrypt("ZophZ2jcm2BOfbtdWvGkFw==")
    $actiontripprdropw=decrypt("gbukCNG2TIyMQzfQkl+nhg==")
    $actiontripprdrwpw=decrypt("uQgxH5bvBfiskST/GVxy7A==")
    file { "/app/shared/actiontrip.com/dbcred/db_actiontrip.com.php":
         ensure => file,
         owner   => deploy,
         group   => deploy,
         mode    => 755,
         content => template('atomiconline/db_actiontrip.com.php'),
         }




}
