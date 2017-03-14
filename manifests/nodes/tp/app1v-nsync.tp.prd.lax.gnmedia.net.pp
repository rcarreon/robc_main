node 'app1v-nsync.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="admin"
        include common::app
        include httpd
        include sqlcopy
        include mysqld56::client

        # duplicity packages for amazon s3 backup
        package { ["duplicity","perl-XML-Parser"]:
            ensure => present,
        }

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_shared/nsync-shared",
        }

        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_log/app1v-nsync.tp.prd.lax.gnmedia.net",
        }




###################################################################################################
###### Inventory ##################################################################################
###################################################################################################

        # inventory.rb, not sure if we are still using it
        file {"/usr/local/bin/inventory.rb":
                owner   => root,
                group   => root,
                mode    => 755,
                source  => "puppet:///modules/common/inventory.rb",
        }





###################################################################################################
###### SVN/GIT BACKUP #############################################################################
###################################################################################################

        $nsyncrootgpgkeyphrase=decrypt("qAFOaeOMcExCfTdV4riMIQ==")
        $nsyncrootgpgencryptkey=decrypt("iik5fyGvgj2j2O5XewCpWw==")
        $tps3_aws_access_key_id=decrypt("lnpjxQEqHIcj3h/RvW4ZnQgudolMviNB+Er1NWh7A2w=")
        $tps3_aws_secret_access_key=decrypt("pjkeFowJbBNe4unTtzKnhmYj8u/A6oiuKs/Q9tkWNS8ImCgCQqqZMsi4beN2K1iR")


##### PGP Keys #####

    file {"/root/.gnupg":
         mode    => 600,
         recurse => true,
         owner => "root",
         group => "root",
         source => "puppet:///modules/common/nsync/gnupg",
         }


##### SVN #####

    	common::nfsmount {"/mnt/nfs1_tp_lax_svn_ops_backup":
        	device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_svn_backup"
    	}

        # get the duplicity backup script in place
        file {"/usr/local/bin/backup_svn_to_s3_cron.sh":
                owner   => root,
                group   => root,
                mode    => 755,
                content => template('techplatform/backup_svn_to_s3_cron.sh'),
        }

        # get the duplicity restore script in place
        file {"/usr/local/bin/restore_svn_from_s3.sh":
                owner   => root,
                group   => root,
                mode    => 755,
                content => template('techplatform/restore_svn_from_s3.sh'),
        }

        # use duplicity to backup svn to s3
        cron { backup_svn_to_s3:
                user    => root,
                ensure  => present,
 		hour	=> 3,
                minute  => 20,
                command => "/bin/bash /usr/local/bin/backup_svn_to_s3_cron.sh > /tmp/svn_to_s3.log 2>&1"
        }


##### GIT #####

        common::nfsmount { "/mnt/nfs1_tp_lax_prd_git_backup":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_git_backup",
        }

        # get the duplicity backup script in place
        file {"/usr/local/bin/backup_git_to_s3_cron.sh":
                owner   => root,
                group   => root,
                mode    => 755,
                content => template('techplatform/backup_git_to_s3_cron.sh'),
        }

        # get the duplicity restore script in place
        file {"/usr/local/bin/restore_git_from_s3.sh":
                owner   => root,
                group   => root,
                mode    => 755,
                content => template('techplatform/restore_git_from_s3.sh'),
        }

        # use duplicity to backup git to s3
        cron { backup_git_to_s3:
                user    => root,
                ensure  => present,
                hour    => 2,
                minute  => 20,
                command => "/bin/bash /usr/local/bin/backup_git_to_s3_cron.sh > /tmp/git_to_s3.log 2>&1"
        }




###################################################################################################
###### Actiontrip #################################################################################
###################################################################################################


    ##### Directory Structure #####
        file { ['/mnt/atomiconline',
                '/mnt/atomiconline/atp',
                '/mnt/atomiconline/atp/stg_ugc',
                '/mnt/atomiconline/atp/prd_ugc']:
             ensure  => directory,
             }

    ##### Mounts #####

        # ATP PRD UGC mount
        common::nfsmount{ "/mnt/atomiconline/atp/prd_ugc":
                device  => "nfsA-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/atp-ugc",
                }

        # ATP STG UGC mount
        common::nfsmount{ "/mnt/atomiconline/atp/stg_ugc":
                device  => "nfsA-netapp1.ao.stg.lax.gnmedia.net:/vol/nac1a_ao_lax_stg_app_shared/atp-ugc",
                }

    ##### Sync Scripts #####

        # get the atp replication script in place
        file {"/usr/local/bin/atp_replicate_cron.sh":
                owner   => root,
                group   => root,
                mode    => 755,
                source  => "puppet:///modules/common/atp_replicate_cron.sh",
        }

    ##### Sync UGC from PRD to STG
        cron { atp_sync_prd_stg:
                user    => root,
                ensure  => present,
                hour    => 23,
                minute  => 10,
                command => "/bin/bash /usr/local/bin/atp_replicate_cron.sh /mnt/atomiconline/atp/prd_ugc /mnt/atomiconline/atp/stg_ugc /tmp/atp-prd2stg-sync.log 2>&1"
        }

###################################################################################################
###### GameRevolution #############################################################################
###################################################################################################

    ##### Directory Structure #####
        file { ['/mnt/atomiconline/gr',
                '/mnt/atomiconline/gr/stg_ugc',
                '/mnt/atomiconline/gr/prd_ugc']:
             ensure  => directory,
             }


    ##### Mounts #####
        # PRD UGC mount
        common::nfsmount{ "/mnt/atomiconline/gr/prd_ugc":
                device  => "nfsA-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/gr-ugc",
                }
        
        # STG UGC mount
        common::nfsmount{ "/mnt/atomiconline/gr/stg_ugc":
                device  => "nfsA-netapp1.ao.stg.lax.gnmedia.net:/vol/nac1a_ao_lax_stg_app_shared/gr-ugc",
                }

    ##### Sync Scripts #####

        # get the gamerevolution replication script in place
        file {"/usr/local/bin/gr_replicate_cron.sh":
                owner   => root,
                group   => root,
                mode    => 755,
                source  => "puppet:///modules/common/gr_replicate_cron.sh",
        }

    ##### Sync UGC from PRD to STG
        cron { gr_sync_prd_stg:
                user    => root,
                ensure  => present,
                hour    => 21,
                minute  => 10,
                command => "/bin/bash /usr/local/bin/gr_replicate_cron.sh /mnt/atomiconline/gr/prd_ugc /mnt/atomiconline/gr/stg_ugc /tmp/gr-prd2stg-sync.log 2>&1"
        }



###################################################################################################
###### Titan/Wordpress ############################################################################
###################################################################################################

    ##### Directory Structure #####
        file { ['/mnt/atomiconline/pbwp',
                '/mnt/atomiconline/pbwp/dev_ugc',
                '/mnt/atomiconline/pbwp/stg_ugc',
                '/mnt/atomiconline/pbwp/www_ugc']:
             ensure  => directory,
             }


    ##### Create Mounts #####
        # DEV UGC mount
          common::nfsmount {"/mnt/atomiconline/pbwp/dev_ugc":
                   device  => "nfsA-netapp1.ao.dev.lax.gnmedia.net:/vol/nac1a_ao_lax_dev_app_shared/wp-ugc",
                   }

        # STG UGC mount
          common::nfsmount {"/mnt/atomiconline/pbwp/stg_ugc":
                   device  => "nfsA-netapp1.ao.stg.lax.gnmedia.net:/vol/nac1a_ao_lax_stg_app_shared/wp-ugc",
                   }

        # WWW UGC mount
          common::nfsmount {"/mnt/atomiconline/pbwp/www_ugc":
                   device  => "nfsA-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/wp-ugc",
                   }


    ##### Sync Scripts #####
        # get the rsync script in place
          file {"/usr/local/bin/pbwp_replicate_cron.sh":
                owner   => root,
                group   => root,
                mode    => 755,
                source  => "puppet:///modules/common/pbwp_replicate_cron.sh",
               }

        # WWW to STG
          cron { pbwp_sync_ugc_www_stg:
                user    => root,
                ensure  => present,
                hour    => 03,
                minute  => 20,
                command => "/bin/bash /usr/local/bin/pbwp_replicate_cron.sh /mnt/atomiconline/pbwp/www_ugc /mnt/atomiconline/pbwp/stg_ugc /tmp/pbwp-www2stg-sync.log 2>&1"
               }

        # STG to DEV
          cron { pbwp_sync_ugc_www_dev:
                user    => root,
                ensure  => present,
                hour    => 05,
                minute  => 20,
                command => "/bin/bash /usr/local/bin/pbwp_replicate_cron.sh /mnt/atomiconline/pbwp/stg_ugc /mnt/atomiconline/pbwp/dev_ugc /tmp/pbwp-stg2dev-sync.log 2>&1"
               }


###################################################################################################
###### Titan/XenForo ##############################################################################
###################################################################################################

    ##### Directory Structure #####
        file { ['/mnt/atomiconline/pbxf',
                '/mnt/atomiconline/pbxf/dev_ugc',
                '/mnt/atomiconline/pbxf/stg_ugc',
                '/mnt/atomiconline/pbxf/www_ugc']:
             ensure  => directory,
             }


    ##### Create Mounts #####
        # DEV UGC mount
          common::nfsmount {"/mnt/atomiconline/pbxf/dev_ugc":
                   device  => "nfsB-netapp1.ao.dev.lax.gnmedia.net:/vol/nac1b_ao_lax_dev_app_ugc/xf-ugc",
                   }

        # STG UGC mount
          common::nfsmount {"/mnt/atomiconline/pbxf/stg_ugc":
                   device  => "nfsB-netapp1.ao.stg.lax.gnmedia.net:/vol/nac1b_ao_lax_stg_app_ugc/xf-ugc",
                   }

        # WWW UGC mount
          common::nfsmount {"/mnt/atomiconline/pbxf/www_ugc":
                   device  => "nfsB-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1b_ao_lax_prd_app_ugc/xf-ugc",
                   }


    ##### Sync Scripts #####
         #Re-using pbwp_replicate_cron.sh, since it's identical

        # WWW to STG
          cron { pbxf_sync_ugc_www_stg:
                user    => root,
                ensure  => present,
                hour    => 03,
                minute  => 20,
                command => "/bin/bash /usr/local/bin/pbwp_replicate_cron.sh /mnt/atomiconline/pbxf/www_ugc /mnt/atomiconline/pbxf/stg_ugc /tmp/pbxf-www2stg-sync.log 2>&1"
               }

        # STG to DEV
          cron { pbxf_sync_ugc_stg_dev:
                user    => root,
                ensure  => present,
                hour    => 05,
                minute  => 20,
                command => "/bin/bash /usr/local/bin/pbwp_replicate_cron.sh /mnt/atomiconline/pbxf/stg_ugc /mnt/atomiconline/pbxf/dev_ugc /tmp/pbxf-stg2dev-sync.log 2>&1"
               }


###################################################################################################
###### Titan/API ##################################################################################
###################################################################################################

    ##### Directory Structure #####
        file { ['/mnt/atomiconline/api',
                '/mnt/atomiconline/api/dev_ugc',
                '/mnt/atomiconline/api/stg_ugc',
                '/mnt/atomiconline/api/www_ugc']:
             ensure  => directory,
             }


    ##### Create Mounts #####
        # DEV UGC mount
          common::nfsmount {"/mnt/atomiconline/api/dev_ugc":
                   device  => "nfsB-netapp1.ao.dev.lax.gnmedia.net:/vol/nac1b_ao_lax_dev_app_ugc/api-ugc",
                   }

        # STG UGC mount
          common::nfsmount {"/mnt/atomiconline/api/stg_ugc":
                   device  => "nfsB-netapp1.ao.stg.lax.gnmedia.net:/vol/nac1b_ao_lax_stg_app_ugc/api-ugc",
                   }

        # WWW UGC mount
          common::nfsmount {"/mnt/atomiconline/api/www_ugc":
                   device  => "nfsB-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1b_ao_lax_prd_app_ugc/api-ugc",
                   }


    ##### Sync Scripts #####
         #Re-using pbwp_replicate_cron.sh, since it's identical

        # WWW to STG
          cron { api_sync_ugc_www_stg:
                user    => root,
                ensure  => present,
                hour    => 04,
                minute  => 20,
                command => "/bin/bash /usr/local/bin/pbwp_replicate_cron.sh /mnt/atomiconline/api/www_ugc /mnt/atomiconline/api/stg_ugc /tmp/api-www2stg-sync.log 2>&1"
               }

        # STG to DEV
          cron { api_sync_ugc_stg_dev:
                user    => root,
                ensure  => present,
                hour    => 06,
                minute  => 20,
                command => "/bin/bash /usr/local/bin/pbwp_replicate_cron.sh /mnt/atomiconline/api/stg_ugc /mnt/atomiconline/api/dev_ugc /tmp/api-stg2dev-sync.log 2>&1"
               }


###################################################################################################
###### Sherdog ####################################################################################
###################################################################################################

    ##### Directory Structure #####
        file { ['/mnt/atomiconline/sdc',
                '/mnt/atomiconline/sdc/dev_ugc',
                '/mnt/atomiconline/sdc/stg_ugc',
                '/mnt/atomiconline/sdc/prd']:
             ensure  => directory,
             }


    ##### Create Mounts #####
        # DEV UGC mount
          common::nfsmount {"/mnt/atomiconline/sdc/dev_ugc":
                   device  => "nfsA-netapp1.ao.dev.lax.gnmedia.net:/vol/nac1a_ao_lax_dev_app_shared/admin.sherdog.com_ugc",
                   }

        # STG UGC mount
          common::nfsmount {"/mnt/atomiconline/sdc/stg_ugc":
                   device  => "nfsB-netapp1.ao.stg.lax.gnmedia.net:/vol/nac1b_ao_lax_stg_app_ugc/admin.sherdog.com_ugc",
                   }

        # PRD UGC mount
          common::nfsmount {"/mnt/atomiconline/sdc/prd_ugc":
                   device  => "nfsA-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1a_ao_lax_prd_app_shared/admin.sherdog.com_ugc",
                   }


    ##### Sync Scripts #####
        # get the rsync script in place
          file {"/usr/local/bin/sdc_replicate_cron.sh":
                owner   => root,
                group   => root,
                mode    => 755,
                content => template('techplatform/sdc_replicate_cron.sh'),
               }


        # PRD to STG
          cron { sdc_sync_ugc_prd_stg:
                user    => root,
                ensure  => present,
		weekday => '6',
                hour    => 04,
                minute  => 40,
                command => "/bin/bash /usr/local/bin/sdc_replicate_cron.sh /mnt/atomiconline/sdc/prd_ugc /mnt/atomiconline/sdc/stg_ugc /tmp/sdc-prd2stg-sync.log 2>&1"
               }

        # STG to DEV
          cron { sdc_sync_ugc_stg_dev:
                user    => root,
                ensure  => present,
		weekday => '6',
                hour    => 06,
                minute  => 40,
                command => "/bin/bash /usr/local/bin/sdc_replicate_cron.sh /mnt/atomiconline/sdc/stg_ugc /mnt/atomiconline/sdc/dev_ugc /tmp/sdc-stg2dev-sync.log 2>&1"
               }



####################
###### Origin ######
####################

    ##### Directory Structure #####
    file { ['/mnt/origin', '/mnt/origin/dev_ugc', '/mnt/origin/stg_ugc', '/mnt/origin/prd']:
            ensure  => directory,
            }


    ##### Create Mounts #####
        # DEV UGC mount
          common::nfsmount {"/mnt/origin/dev_ugc":
                   device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_dev_app_ugc",
                   }

        # STG UGC mount
          common::nfsmount {"/mnt/origin/stg_ugc":
                   device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_stg_app_ugc",
                   }

        # PRD UGC mount
          common::nfsmount {"/mnt/origin/prd_ugc":
                   device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_prd_app_ugc",
                   }


    ##### Sync Scripts #####
        # get the rsync script in place
          file {"/usr/local/bin/og_mgmt_replicate_cron.sh":
                owner   => root,
                group   => root,
                mode    => 755,
                content => template('techplatform/og_mgmt_replicate_cron.sh'),
               }

        # PRD to STG
          cron { og_sync_ugc_prd_stg:
                user    => root,
                ensure  => present,
		weekday => '7',
                hour    => 04,
                minute  => 40,
                command => "/bin/bash /usr/local/bin/og_mgmt_replicate_cron.sh /mnt/origin/prd_ugc /mnt/origin/stg_ugc /tmp/origin-prd2stg-sync.log 2>&1"
               }

        # STG to DEV
          cron { og_sync_ugc_stg_dev:
                user    => root,
                ensure  => present,
		weekday => '7',
                hour    => 06,
                minute  => 40,
                command => "/bin/bash /usr/local/bin/og_mgmt_replicate_cron.sh /mnt/origin/stg_ugc /mnt/origin/dev_ugc /tmp/origin-stg2dev-sync.log 2>&1"
               }

###################################################################################################
###### Crowdignite ################################################################################
###################################################################################################

  # Local mount points
  file { ['/mnt/crowdignite', '/mnt/crowdignite/dev_stg_ugc', '/mnt/crowdignite/prd_ugc',]:
    ensure => directory,
  }

  # nfs volumes
  common::nfsmount { '/mnt/crowdignite/dev_stg_ugc':
    device  => "nfsA-netapp1.ci.stg.lax.gnmedia.net:/vol/nac1a_ci_lax_stg_app_ugc_tmp/upload",
  }

  common::nfsmount { '/mnt/crowdignite/prd_ugc':
    device  => "nfsB-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1b_ci_lax_prd_app_ugc_tmp/upload",
  }

  common::nfsmount { '/mnt/crowdignite/prd_shared':
    device  => "nfsA-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_shared/ci-shared",
  }

################################################################################
###### Ad Platform / AdOps #####################################################
################################################################################

  # prd db sync to reports-qa box
  sqlcopy::cron { 'ap_prd_reports-qa':
    ensure  => 'absent', # temporarily disabling - sdejean 20151113
    mapfile => 'ap_prd_reports.sqlcopy',
    mailto  => 'DBA@evolvemediallc.com,AdDevelopers@evolvemediallc.com',
    user    => 'root',
    weekday => '0',
    minute  => '0',
    hour    => '4',
  }


}
