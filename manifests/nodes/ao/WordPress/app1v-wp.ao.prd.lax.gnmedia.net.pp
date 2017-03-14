node 'app1v-wp.ao.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        include wordpresspb::appserver
        include wordpresspb::pbwb_appprd_dbcred
    $project="atomiconline"
    $httpd="pbwordpress"
#        include ganglia::modules::mod_sflow

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/wp-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app1v-wp.ao.prd.lax.gnmedia.net",
        }

        common::ugcmount { "/app/ugc":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/wp-ugc",
        }

    # Wordpress Cron Script
    file {"/usr/local/bin/wp_cron.sh":
        ensure => file,
        owner   => deploy,
        group   => deploy,
        mode    => 755,
        content => template('atomiconline/wp_cron.sh'),
        }

    cron { wp_cron:
        user    => deploy,
        ensure  => present,
        minute  => '*/5',
        command => "/usr/local/bin/wp_cron.sh"
    }

}
