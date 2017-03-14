node 'app2v-mc.ao.stg.lax.gnmedia.net' {
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
    sphinx::conf { 'stg-mostcraved': reindex => false, }
    include mysqld56::client
    class {'php::install': version => '5.3', extra_packages => ["php-mbstring"]}
    include ganglia::modules::mod_sflow


############################################################################
##### Set up vhost #########################################################
############################################################################

    httpd::virtual_host { 'stg.mostcraved.craveonline.com': monitor => false,}


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

    $stgpbmostcravedw=decrypt("/mLQEr52QwKsUDt8S0yzWg==")
    file { "/app/shared/mostcraved/dbcred/db_mostcraved.php":
                content => template('atomiconline/stg_db_mostcraved.php'),
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
		weekday => 3,
                hour => 4,
                minute  => 0,
                command => "/usr/bin/php -q /app/shared/mostcraved/current/cron.php > /tmp/mostcraved_cron.log"
         }
         
    cron { resync_social_index:
                user    => deploy,
                ensure  => present,
		weekday => 3,
                hour => 5,
                minute  => 0,
                command => "/usr/bin/php -q /app/shared/mostcraved/current/cron_social.php > /tmp/mostcraved_cron_social.log"
         }

    cron { rebuild_index:
                user    => sphinx,
                ensure  => present,
		weekday => [1,2,3,4,5],
                hour => 6,
                minute  => 0,
                command => "/usr/bin/indexer --config /etc/sphinx/sphinx.conf --all --rotate  > /tmp/mostcraved_reindex.log"
         }



############################################################################
##### Mount Shares #########################################################
############################################################################

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_stg_app_shared/mc-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_stg_app_log/app2v-mc.ao.stg.lax.gnmedia.net",
    }



}
