node 'app1v-git.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="admin"
        include common::app
        include httpd::ssl
        include git::server


        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_shared/git-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_log/app1v-git.tp.prd.lax.gnmedia.net",
        }

        ###################################################################################################
        ###### Backup #####################################################################################
        ###################################################################################################

        common::nfsmount { "/mnt/nfs1_tp_lax_prd_git_backup":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_git_backup",
        }

        file {"/usr/local/bin/git_snapshot.sh":
                owner   => root,
                group   => root,
                mode    => 755,
                content => template('techplatform/git_snapshot.sh'),
        }

        cron { nightly_snapshot:
                user    => root,
                ensure  => present,
                hour    => 1,
                minute  => 45,
                command => "/usr/local/bin/git_snapshot.sh"
        }
}
