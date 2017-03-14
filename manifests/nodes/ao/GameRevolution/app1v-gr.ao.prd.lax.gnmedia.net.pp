node 'app1v-gr.ao.prd.lax.gnmedia.net' {
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
        $grproddbpass =decrypt("wmb+XsJi46uJta4+2vh8Gg==")

        httpd::virtual_host {"gamerevolution.com":}

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/gamerev-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app1v-gr.ao.prd.lax.gnmedia.net",
        }

        common::nfsmount { "/app/ugc":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/gr-ugc",
        }

    file { "/app/shared/docroots/gamerevolution.com/config":
        ensure => directory,
        owner  => "root",
        group  => "root",
    }

    file { "/app/shared/docroots/gamerevolution.com/config/config.php":
         content => template('atomiconline/prd_db_gamerevolution.php'),
         owner  => "root",
         group  => "root",
         require => File["/app/shared/docroots/gamerevolution.com/config"],
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

    cron { game_daily:
        user    => deploy,
        minute  => 30,
        hour    => [12,18],
        ensure  => "absent",
        command => "/usr/bin/php -q /app/shared/docroots/gamerevolution.com/htdocs/admin_files/cron/game_daily.php",
    }
    cron { import_videos:
        user    => deploy,
        minute  => 30,
        hour    => '*/3',
        ensure  => "present",
        command => "/usr/bin/php -q /app/shared/docroots/gamerevolution.com/htdocs/admin_files/cron/import_videos.php",
    }
    cron { fetch_release_lists:
        user    => deploy,
        minute  => 0,
        hour    => 23,
        ensure  => "present",
        command => "/usr/bin/php -q /app/shared/docroots/gamerevolution.com/htdocs/admin_files/cron/fetch_release_lists.php",
    }
    cron { fetch_comics:
        ensure  => "absent",
    }
    cron { cheat_links_actionscript:
        user    => deploy,
        minute  => 0,
        hour    => 5,
        monthday => '*/2',
        ensure  => "absent",
        command => "/usr/bin/php -q /app/shared/docroots/gamerevolution.com/htdocs/admin_files/cron/cheat_links_actiontrip.php",
    }
    cron { cheat_links_cheathappens:
        user    => deploy,
        minute  => 0,
        hour    => 6,
        monthday => '*/15',
        ensure  => "present",
        command => "/usr/bin/php -q /app/shared/docroots/gamerevolution.com/htdocs/admin_files/cron/cheat_links_cheathappens.php",
    }
    cron { cheat_links_vgchartz:
        user    => deploy,
        minute  => 15,
        hour    => 1,
        weekday => 3,
        ensure  => "present",
        command => "/usr/bin/php -q /app/shared/docroots/gamerevolution.com/htdocs/admin_files/cron/cheat_links_vgchartz.php",
    }
    cron {  cheat_links_absolutcheats:
        user    => deploy,
        minute  => 30,
        hour    => 3,
        weekday => 4,
        ensure  => "present",
        command => "/usr/bin/php -q /app/shared/docroots/gamerevolution.com/htdocs/admin_files/cron/cheat_links_absolutcheats.php",
    }
    cron { cheat_links_cheatfreak:
        user    => deploy,
        minute  => 30,
        hour    => 2,
        weekday => 4,
        ensure  => "present",
        command => "/usr/bin/php -q /app/shared/docroots/gamerevolution.com/htdocs/admin_files/cron/cheat_links_cheatfreak.php",
    }
    cron { cheat_links_chaptercheats:
        user    => deploy,
        minute  => 10,
        hour    => 4,
        weekday => 0,
        ensure  => "present",
        command => "/usr/bin/php -q /app/shared/docroots/gamerevolution.com/htdocs/admin_files/cron/cheat_links_chaptercheats.php",
    }
    cron { cheat_links_cheatingdome:
        user     => deploy,
        minute   => 25,
        hour     => 4,
        monthday => 5,
        ensure   => "present",
        command  => "/usr/bin/php -q /app/shared/docroots/gamerevolution.com/htdocs/admin_files/cron/cheat_links_cheatingdome.php",
    }
    cron { cheat_links_gameanyone:
        user    => deploy,
        minute  => 45,
        hour    => 2,
        weekday => 2,
        ensure  => "present",
        command => "/usr/bin/php -q /app/shared/docroots/gamerevolution.com/htdocs/admin_files/cron/cheat_links_gameanyone.php",
    }
    cron { cheat_links_gamewallpapers:
        user    => deploy,
        minute  => 35,
        hour    => 3,
        weekday => 3,
        ensure  => "present",
        command => "/usr/bin/php -q /app/shared/docroots/gamerevolution.com/htdocs/admin_files/cron/cheat_links_bestgamewallpapers.php",
    }
    cron { cheat_links_cheatsgurus:
        user    => deploy,
        minute  => 35,
        hour    => 3,
        weekday => 2,
        ensure  => "present",
        command => "/usr/bin/php -q /app/shared/docroots/gamerevolution.com/htdocs/admin_files/cron/cheat_links_cheatsguru.php",
    }
    cron { fetch_esrb:
        user    => deploy,
        minute  => 35,
        hour    => 3,
        weekday => 1,
        ensure  => "present",
        command => "/usr/bin/php -q /app/shared/docroots/gamerevolution.com/htdocs/admin_files/cron/fetch_esrb.php",
    }
    cron { review_links_vgchartz:
        user    => deploy,
        minute  => 30,
        hour    => 22,
        weekday => 4,
        ensure  => "present",
        command => "/usr/bin/php -q /app/shared/docroots/gamerevolution.com/htdocs/admin_files/cron/review_links_vgchartz.php",
    }
    cron { cheat_links_xbox360cheats:
        user    => deploy,
        minute  => 55,
        hour    => 20,
        weekday => 5,
        ensure  => "present",
        command => "/usr/bin/php -q /app/shared/docroots/gamerevolution.com/htdocs/admin_files/cron/cheat_links_xbox360cheats.php",
    }
    cron { hourly_job:
        user    => deploy,
        minute  => 5,
        hour    => '*',
        ensure  => "present",
        command => "/usr/bin/php -q /app/shared/docroots/gamerevolution.com/htdocs/admin_files/cron/hourly_job.php",
    }

}
