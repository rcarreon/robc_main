node 'app1v-mc.ao.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project="atomiconline"

############################################################################
##### Packages to be installed on app servers ##############################
############################################################################

    include common::app
    include httpd
    include subversion::client
    sphinx::conf { 'dev-mostcraved': reindex => false, }
    include mysqld56::client
    class {'php::install': version => '5.3', extra_packages => ["php-mbstring"]}


############################################################################
##### Set up vhost #########################################################
############################################################################

    httpd::virtual_host { 'dev.mostcraved.craveonline.com': monitor => false,}


############################################################################
##### Set up application directory structure ###############################
############################################################################

    file { ['/app/shared/mostcraved',
            '/app/shared/mostcraved/dbcred',
            '/app/shared/mostcraved/releases']:
                owner => "deploy",
                group => "deploy",
                mode => 755,
                ignore => ".svn",
                require => Mount["/app/shared"],
         }


############################################################################
##### Create dbcred file ###################################################
############################################################################

    $devpbmostcravedw=decrypt("qSbhEKO2Zp567yxHGTOKQA==")
    file { "/app/shared/mostcraved/dbcred/db_mostcraved.php":
                content => template('atomiconline/dev_db_mostcraved.php'),
                ensure => file,
                mode => 644,
                owner => "deploy",
                group => "deploy",
         }


############################################################################
##### Create reindex cron ##################################################
############################################################################

    cron { resync_index:
                user    => deploy,
                ensure  => present,
                weekday => 1,
                hour => 1,
                minute  => 0,
                command => "/usr/bin/php -q /app/shared/mostcraved/current/cron.php > /tmp/mostcraved_cron.log"
         }

    cron { resync_social_index:
                user    => deploy,
                ensure  => present,
                weekday => 1,
                hour => 2,
                minute  => 0,
                command => "/usr/bin/php -q /app/shared/mostcraved/current/cron_social.php > /tmp/mostcraved_cron_social.log"
         }

    cron { rebuild_index:
                user    => sphinx,
                ensure  => present,
                weekday => 1,
                hour => 3,
                minute  => 0,
                command => "/usr/bin/indexer --config /etc/sphinx/sphinx.conf --all --rotate  > /tmp/mostcraved_reindex.log"
         }


############################################################################
##### Mount Shares #########################################################
############################################################################

    common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_shared/mc-shared",
    }

    common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_app_log/app1v-mc.ao.dev.lax.gnmedia.net",
    }

}
