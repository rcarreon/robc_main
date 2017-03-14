node 'app2v-cap.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="admin"


############################################################################
##### Install required packages ############################################
############################################################################
    include common::app
    include rubygems::capistrano
    include rubygems::colored
    include subversion::client
    include mysqld56::client
    include util::vim
    include git::client
    class { 'php::install': }

    package {"rubygem-bundler":
      ensure => present,
    }


############################################################################
##### Define vhosts ########################################################
############################################################################
    httpd::virtual_host {"caplog.gnmedia.net":expect => "websvn.gnmedia.net"}


############################################################################
##### Manage Encrypted Database Credential Files ###########################
############################################################################
    include wordpresspb::pbwb_dbcred


############################################################################
##### Manage Files, Directories, and Mounts ################################
############################################################################

  common::nfsmount {"/app/shared":
            device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_shared/cap-shared",
           }

  common::nfsmount {"/app/log":
            device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_tp_lax_prd_app_log/app2v-cap.tp.prd.lax.gnmedia.net",
           }
        
  file {"/app/shared/projects":
        ensure  => directory,
        owner   => deploy,
        require => Common::Nfsmount["/app/shared"],
        }

    file { "/app/shared/caplog":
      ensure  => directory,
      owner   => deploy,
      require => Common::Nfsmount["/app/shared"],
         }
       
}
