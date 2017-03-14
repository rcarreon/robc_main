node 'app1v-mc.ao.prd.lax.gnmedia.net' {
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
    sphinx::conf { 'prd-mostcraved': reindex => false, }
    include mysqld56::client
    class {'php::install': version => '5.3', extra_packages => ["php-mbstring"]}
    include ganglia::modules::mod_sflow


############################################################################
##### Set up vhost #########################################################
############################################################################

    httpd::virtual_host { 'mostcraved.craveonline.com': monitor => false,}


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

    $prdpbmostcravedw=decrypt("WYMmdOmNwiaE1VVxjkPvZA==")
    file { "/app/shared/mostcraved/dbcred/db_mostcraved.php":
                content => template('atomiconline/app1v_prd_db_mostcraved.php'),
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
		hour    => [1,3,5,7,9,11,13,15,17,19,21,23],
                minute  => 15,
                command => "/usr/bin/php -q /app/shared/mostcraved/current/cron.php > /tmp/mostcraved_cron.log"
         }

    cron { resync_social_index:
                user    => deploy,
                ensure  => present,
		hour    => [1,3,5,7,9,11,13,15,17,19,21,23],
                minute  => 30,
                command => "/usr/bin/php -q /app/shared/mostcraved/current/cron_social.php > /tmp/mostcraved_cron_social.log"
         }

    cron { rebuild_index:
                user    => sphinx,
                ensure  => present,
                minute  => 10,
                command => "/usr/bin/indexer --config /etc/sphinx/sphinx.conf --all --rotate  > /tmp/mostcraved_reindex.log"
         }



############################################################################
##### Mount Shares #########################################################
############################################################################

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/mc-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app1v-mc.ao.prd.lax.gnmedia.net",
    }
}
