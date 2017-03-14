# $URL$

node 'app1v-log.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project="admin"

        include httpd

###################################################################################################
###### AdPlatform ##### ###########################################################################
###################################################################################################

    # PRD
    common::nfsromount {"/mnt/ap/prd/odd":
        device => "nfsA-netapp1.ap.prd.lax.gnmedia.net:/vol/nac1a_ap_lax_prd_app_log/",
    }
    common::nfsromount {"/mnt/ap/prd/even":
        device => "nfsB-netapp1.ap.prd.lax.gnmedia.net:/vol/nac1b_ap_lax_prd_app_log/",
    }

    # STG
    common::nfsromount {"/mnt/ap/stg/odd":
        device => "nfsA-netapp1.ap.stg.lax.gnmedia.net:/vol/nac1a_ap_lax_stg_app_log/",
    }
    common::nfsromount {"/mnt/ap/stg/even":
        device => "nfsB-netapp1.ap.stg.lax.gnmedia.net:/vol/nac1b_ap_lax_stg_app_log/",
    }


###################################################################################################
###### Pebblebed/Wordpress PRD ####################################################################
###################################################################################################

  ##### APP PRD Servers #####

      ##### Mounts #####
        common::nfsromount {"/mnt/ao/app1v-wp.ao.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app1v-wp.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app2v-wp.ao.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app2v-wp.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app3v-wp.ao.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app3v-wp.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app4v-wp.ao.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app4v-wp.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app5v-wp.ao.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app5v-wp.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app6v-wp.ao.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app6v-wp.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app7v-wp.ao.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app7v-wp.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app8v-wp.ao.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app8v-wp.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app100v-wp.ao.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app100v-wp.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app101v-wp.ao.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app101v-wp.ao.prd.lax.gnmedia.net",
                 }

  ##### PXY PRD Servers #####

      ##### Mounts #####
        common::nfsromount {"/mnt/ao/pxy1v-wp.ao.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1a_ao_lax_prd_pxy_log/pxy1v-wp.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/pxy2v-wp.ao.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1b_ao_lax_prd_pxy_log/pxy2v-wp.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/pxy3v-wp.ao.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1a_ao_lax_prd_pxy_log/pxy3v-wp.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/pxy4v-wp.ao.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1b_ao_lax_prd_pxy_log/pxy4v-wp.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/pxy100v-wp.ao.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1a_ao_lax_prd_pxy_log/pxy100v-wp.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/pxy101v-wp.ao.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1b_ao_lax_prd_pxy_log/pxy101v-wp.ao.prd.lax.gnmedia.net",
                 }

###################################################################################################
###### Pebblebed/Wordpress STG ####################################################################
###################################################################################################

  ##### APP STG Servers #####

      ##### Mounts #####
        common::nfsromount {"/mnt/ao/app1v-wp.ao.stg.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ao.stg.lax.gnmedia.net:/vol/nac1a_ao_lax_stg_app_log/app1v-wp.ao.stg.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app2v-wp.ao.stg.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ao.stg.lax.gnmedia.net:/vol/nac1b_ao_lax_stg_app_log/app2v-wp.ao.stg.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app100v-wp.ao.stg.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ao.stg.lax.gnmedia.net:/vol/nac1b_ao_lax_stg_app_log/app100v-wp.ao.stg.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app101v-wp.ao.stg.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ao.stg.lax.gnmedia.net:/vol/nac1a_ao_lax_stg_app_log/app101v-wp.ao.stg.lax.gnmedia.net",
                 }

  ##### PXY STG Servers #####

      ##### Mounts #####
        common::nfsromount {"/mnt/ao/pxy1v-wp.ao.stg.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ao.stg.lax.gnmedia.net:/vol/nac1a_ao_lax_stg_pxy_log/pxy1v-wp.ao.stg.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/pxy2v-wp.ao.stg.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ao.stg.lax.gnmedia.net:/vol/nac1b_ao_lax_stg_pxy_log/pxy2v-wp.ao.stg.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/pxy100v-wp.ao.stg.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ao.stg.lax.gnmedia.net:/vol/nac1b_ao_lax_stg_pxy_log/pxy100v-wp.ao.stg.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/pxy101v-wp.ao.stg.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ao.stg.lax.gnmedia.net:/vol/nac1a_ao_lax_stg_pxy_log/pxy101v-wp.ao.stg.lax.gnmedia.net",
                 }


###################################################################################################
###### Pebblebed/Wordpress DEV ####################################################################
###################################################################################################

  ##### APP DEV Servers #####

      ##### Mounts #####
        common::nfsromount {"/mnt/ao/app1v-wp.ao.dev.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ao.dev.lax.gnmedia.net:/vol/nac1a_ao_lax_dev_app_log/app1v-wp.ao.dev.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app2v-wp.ao.dev.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ao.dev.lax.gnmedia.net:/vol/nac1a_ao_lax_dev_app_log/app2v-wp.ao.dev.lax.gnmedia.net",
                 }


  ##### PXY DEV Servers #####

      ##### Mounts #####
        common::nfsromount {"/mnt/ao/pxy1v-wp.ao.dev.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ao.dev.lax.gnmedia.net:/vol/nac1a_ao_lax_dev_pxy_log/pxy1v-wp.ao.dev.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/pxy2v-wp.ao.dev.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ao.dev.lax.gnmedia.net:/vol/nac1b_ao_lax_dev_pxy_log/pxy2v-wp.ao.dev.lax.gnmedia.net",
                 }



###################################################################################################
###### Titans/XenForo DEV #########################################################################
###################################################################################################

  ##### APP DEV Servers #####

      ##### Mounts #####
        common::nfsromount {"/mnt/ao/app1v-xf-psl.ao.dev.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ao.dev.lax.gnmedia.net:/vol/nac1a_ao_lax_dev_app_log/app1v-xf-psl.ao.dev.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app2v-xf-psl.ao.dev.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ao.dev.lax.gnmedia.net:/vol/nac1b_ao_lax_dev_app_log/app2v-xf-psl.ao.dev.lax.gnmedia.net",
                 }



###################################################################################################
###### Titans/XenForo STG #########################################################################
###################################################################################################

  ##### APP STG Servers #####

      ##### Mounts #####
        common::nfsromount {"/mnt/ao/app1v-xf-psl.ao.stg.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ao.stg.lax.gnmedia.net:/vol/nac1b_ao_lax_stg_app_log/app1v-xf-psl.ao.stg.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app2v-xf-psl.ao.stg.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ao.stg.lax.gnmedia.net:/vol/nac1b_ao_lax_stg_app_log/app2v-xf-psl.ao.stg.lax.gnmedia.net",
                 }



###################################################################################################
###### Titans/XenForo PRD #########################################################################
###################################################################################################

  ##### APP PRD Servers #####

      ##### Mounts #####
        common::nfsromount {"/mnt/ao/app1v-xf-psl.ao.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app1v-xf-psl.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app2v-xf-psl.ao.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app2v-xf-psl.ao.prd.lax.gnmedia.net",
                 }


###################################################################################################
###### The Fashion Spot ###########################################################################
###################################################################################################

      ##### app1v-vb-tfs.ao.prd.lax.gnmedia.net
        common::nfsromount { "/mnt/ao/app1v-vb-tfs.ao.prd.lax.gnmedia.net":
                device  => "nfsA-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app1v-vb-tfs.ao.prd.lax.gnmedia.net",
        }

      ##### app2v-vb-tfs.ao.prd.lax.gnmedia.net
        common::nfsromount { "/mnt/ao/app2v-vb-tfs.ao.prd.lax.gnmedia.net":
                device  => "nfsB-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app2v-vb-tfs.ao.prd.lax.gnmedia.net",
        }

      ##### app3v-vb-tfs.ao.prd.lax.gnmedia.net
        common::nfsromount { "/mnt/ao/app3v-vb-tfs.ao.prd.lax.gnmedia.net":
                device  => "nfsA-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app3v-vb-tfs.ao.prd.lax.gnmedia.net",
        }

      ##### app4v-vb-tfs.ao.prd.lax.gnmedia.net
        common::nfsromount { "/mnt/ao/app4v-vb-tfs.ao.prd.lax.gnmedia.net":
                device  => "nfsB-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app4v-vb-tfs.ao.prd.lax.gnmedia.net",
        }

###################################################################################################
###### sherdog.com ################################################################################
###################################################################################################

        common::nfsromount { "/mnt/sherdog/app7v-sdc.ao.prd.lax.gnmedia.net":
                device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app7v-sdc.ao.prd.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/sherdog/app8v-sdc.ao.prd.lax.gnmedia.net":
                device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app8v-sdc.ao.prd.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/sherdog/app4v-sdc.ao.prd.lax.gnmedia.net":
                device => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app4v-sdc.ao.prd.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/sherdog/app6v-sdc.ao.prd.lax.gnmedia.net":
                device => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app6v-sdc.ao.prd.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/sherdog/app3v-sdc.ao.prd.lax.gnmedia.net":
                device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app3v-sdc.ao.prd.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/sherdog/app2v-sdc.ao.prd.lax.gnmedia.net":
                device => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app2v-sdc.ao.prd.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/sherdog/app5v-sdc.ao.prd.lax.gnmedia.net":
                device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app5v-sdc.ao.prd.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/sherdog/app1v-sdc.ao.prd.lax.gnmedia.net":
                device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app1v-sdc.ao.prd.lax.gnmedia.net",
        }

###################################################################################################
###### Unified VB PRD #############################################################################
###################################################################################################

  ##### APP PRD Servers #####

      ##### Mounts #####
        common::nfsromount {"/mnt/ao/app1v-vb.ao.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app1v-vb.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app2v-vb.ao.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app2v-vb.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app3v-vb.ao.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app3v-vb.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app4v-vb.ao.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app4v-vb.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app5v-vb.ao.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app5v-vb.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app6v-vb.ao.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app6v-vb.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app7v-vb.ao.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app7v-vb.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app8v-vb.ao.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app8v-vb.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app9v-vb.ao.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app9v-vb.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app10v-vb.ao.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app10v-vb.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app11v-vb.ao.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app11v-vb.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app12v-vb.ao.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app12v-vb.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app13v-vb.ao.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app13v-vb.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app14v-vb.ao.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app14v-vb.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app15v-vb.ao.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app15v-vb.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app16v-vb.ao.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app16v-vb.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app17v-vb.ao.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app17v-vb.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app100v-vb.ao.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app100v-vb.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app101v-vb.ao.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app101v-vb.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app102v-vb.ao.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app102v-vb.ao.prd.lax.gnmedia.net",
                 }


###################################################################################################
###### APP WZF LOGS ###############################################################################
###################################################################################################
        common::nfsromount {"/mnt/ao/app1v-wzf.ao.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1a_ao_lax_prd_app_log/app1v-wzf.ao.prd.lax.gnmedia.net",
                 }
        common::nfsromount {"/mnt/ao/app2v-wzf.ao.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ao.prd.lax.gnmedia.net:/vol/nac1b_ao_lax_prd_app_log/app2v-wzf.ao.prd.lax.gnmedia.net",
                 }
###################################################################################################
###### Crowdignite ################################################################################
###################################################################################################
# vw analytics
common::nfsmount { "/mnt/crowdignite/landinganalytics/app1v-ci.ci.prd.lax.gnmedia.net":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_prd_app_data/app1v-ci.ci.prd.lax.gnmedia.net",
    }

    common::nfsmount { "/mnt/crowdignite/landinganalytics/app2v-ci.ci.prd.lax.gnmedia.net":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ci_lax_prd_app_data/app2v-ci.ci.prd.lax.gnmedia.net",
    }

    common::nfsmount { "/mnt/crowdignite/landinganalytics/app3v-ci.ci.prd.lax.gnmedia.net":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_prd_app_data/app3v-ci.ci.prd.lax.gnmedia.net",
    }

    common::nfsmount { "/mnt/crowdignite/landinganalytics/app4v-ci.ci.prd.lax.gnmedia.net":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ci_lax_prd_app_data/app4v-ci.ci.prd.lax.gnmedia.net",
    }

    common::nfsmount { "/mnt/crowdignite/landinganalytics/app5v-ci.ci.prd.lax.gnmedia.net":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_prd_app_data/app5v-ci.ci.prd.lax.gnmedia.net",
    }

    common::nfsmount { "/mnt/crowdignite/landinganalytics/app6v-ci.ci.prd.lax.gnmedia.net":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ci_lax_prd_app_data/app6v-ci.ci.prd.lax.gnmedia.net",
    }

    common::nfsmount { "/mnt/crowdignite/landinganalytics/app7v-ci.ci.prd.lax.gnmedia.net":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_prd_app_data/app7v-ci.ci.prd.lax.gnmedia.net",
    }

    common::nfsmount { "/mnt/crowdignite/landinganalytics/app8v-ci.ci.prd.lax.gnmedia.net":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ci_lax_prd_app_data/app8v-ci.ci.prd.lax.gnmedia.net",
    }

    common::nfsmount { "/mnt/crowdignite/widgetanalytics/ngx1v-ci.ci.prd.lax.gnmedia.net":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_prd_app_data/ngx1v-ci.ci.prd.lax.gnmedia.net",
    }

    common::nfsmount { "/mnt/crowdignite/widgetanalytics/ngx2v-ci.ci.prd.lax.gnmedia.net":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ci_lax_prd_app_data/ngx2v-ci.ci.prd.lax.gnmedia.net",
    }

    common::nfsmount { "/mnt/crowdignite/widgetanalytics/ngx3v-ci.ci.prd.lax.gnmedia.net":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_prd_app_data/ngx3v-ci.ci.prd.lax.gnmedia.net",
    }

    common::nfsmount { "/mnt/crowdignite/widgetanalytics/ngx4v-ci.ci.prd.lax.gnmedia.net":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ci_lax_prd_app_data/ngx4v-ci.ci.prd.lax.gnmedia.net",
    }

    common::nfsmount { "/mnt/crowdignite/widgetanalytics/ngx5v-ci.ci.prd.lax.gnmedia.net":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_prd_app_data/ngx5v-ci.ci.prd.lax.gnmedia.net",
    }
    common::nfsmount { "/mnt/crowdignite/widgetanalytics/ngx6v-ci.ci.prd.lax.gnmedia.net":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ci_lax_prd_app_data/ngx6v-ci.ci.prd.lax.gnmedia.net",
    }

    common::nfsmount { "/mnt/crowdignite/widgetanalytics/ngx7v-ci.ci.prd.lax.gnmedia.net":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_prd_app_data/ngx7v-ci.ci.prd.lax.gnmedia.net",
    }

    common::nfsmount { "/mnt/crowdignite/widgetanalytics/ngx8v-ci.ci.prd.lax.gnmedia.net":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ci_lax_prd_app_data/ngx8v-ci.ci.prd.lax.gnmedia.net",
    }

    common::nfsmount { "/mnt/crowdignite/widgetanalytics/ngx9v-ci.ci.prd.lax.gnmedia.net":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_prd_app_data/ngx9v-ci.ci.prd.lax.gnmedia.net",
    }

    common::nfsmount { "/mnt/crowdignite/widgetanalytics/ngx10v-ci.ci.prd.lax.gnmedia.net":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ci_lax_prd_app_data/ngx10v-ci.ci.prd.lax.gnmedia.net",
    }
    

#### Crowdignite log volumes
## app-ci-prd
        common::nfsromount { "/mnt/crowdignite/app1v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_log/app1v-ci.ci.prd.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/app2v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1b_ci_lax_prd_app_log/app2v-ci.ci.prd.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/app3v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_log/app3v-ci.ci.prd.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/app4v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1b_ci_lax_prd_app_log/app4v-ci.ci.prd.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/app5v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_log/app5v-ci.ci.prd.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/app6v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1b_ci_lax_prd_app_log/app6v-ci.ci.prd.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/app7v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_log/app7v-ci.ci.prd.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/app8v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1b_ci_lax_prd_app_log/app8v-ci.ci.prd.lax.gnmedia.net",
  	}

## app-ci-stg
        common::nfsromount { "/mnt/crowdignite/app1v-ci.ci.stg.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.stg.lax.gnmedia.net:/vol/nac1a_ci_lax_stg_app_log/app1v-ci.ci.stg.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/app2v-ci.ci.stg.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.stg.lax.gnmedia.net:/vol/nac1b_ci_lax_stg_app_log/app2v-ci.ci.stg.lax.gnmedia.net",
  	}

## app-vw-prd
        common::nfsromount { "/mnt/crowdignite/app1v-vw.ci.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_log/app1v-vw.ci.prd.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/app2v-vw.ci.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1b_ci_lax_prd_app_log/app2v-vw.ci.prd.lax.gnmedia.net",
  	}

## app-vw-stg
        common::nfsromount { "/mnt/crowdignite/app1v-vw.ci.stg.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.stg.lax.gnmedia.net:/vol/nac1a_ci_lax_stg_app_log/app1v-vw.ci.stg.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/app2v-vw.ci.stg.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.stg.lax.gnmedia.net:/vol/nac1b_ci_lax_stg_app_log/app2v-vw.ci.stg.lax.gnmedia.net",
  	}

## ngx-ci-prd
        common::nfsromount { "/mnt/crowdignite/ngx1v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_log/ngx1v-ci.ci.prd.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/ngx2v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1b_ci_lax_prd_app_log/ngx2v-ci.ci.prd.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/ngx3v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_log/ngx3v-ci.ci.prd.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/ngx4v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1b_ci_lax_prd_app_log/ngx4v-ci.ci.prd.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/ngx5v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_log/ngx5v-ci.ci.prd.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/ngx6v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1b_ci_lax_prd_app_log/ngx6v-ci.ci.prd.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/ngx7v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_log/ngx7v-ci.ci.prd.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/ngx8v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1b_ci_lax_prd_app_log/ngx8v-ci.ci.prd.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/ngx9v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_log/ngx9v-ci.ci.prd.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/ngx10v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1b_ci_lax_prd_app_log/ngx10v-ci.ci.prd.lax.gnmedia.net",
  	}

## ngx-ci-stg
        common::nfsromount { "/mnt/crowdignite/ngx1v-ci.ci.stg.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.stg.lax.gnmedia.net:/vol/nac1a_ci_lax_stg_app_log/ngx1v-ci.ci.stg.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/ngx2v-ci.ci.stg.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.stg.lax.gnmedia.net:/vol/nac1b_ci_lax_stg_app_log/ngx2v-ci.ci.stg.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/ngx3v-ci.ci.stg.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.stg.lax.gnmedia.net:/vol/nac1a_ci_lax_stg_app_log/ngx3v-ci.ci.stg.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/ngx4v-ci.ci.stg.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.stg.lax.gnmedia.net:/vol/nac1b_ci_lax_stg_app_log/ngx4v-ci.ci.stg.lax.gnmedia.net",
  	}

## eng-ci-prd
        common::nfsromount { "/mnt/crowdignite/eng1v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_log/eng1v-ci.ci.prd.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/eng2v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1b_ci_lax_prd_app_log/eng2v-ci.ci.prd.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/eng3v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_log/eng3v-ci.ci.prd.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/eng4v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1b_ci_lax_prd_app_log/eng4v-ci.ci.prd.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/eng5v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_log/eng5v-ci.ci.prd.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/eng6v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1b_ci_lax_prd_app_log/eng6v-ci.ci.prd.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/eng7v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_log/eng7v-ci.ci.prd.lax.gnmedia.net",
  	}

## eng-ci-stg
        common::nfsromount { "/mnt/crowdignite/eng1v-ci.ci.stg.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.stg.lax.gnmedia.net:/vol/nac1a_ci_lax_stg_app_log/eng1v-ci.ci.stg.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/eng2v-ci.ci.stg.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.stg.lax.gnmedia.net:/vol/nac1b_ci_lax_stg_app_log/eng2v-ci.ci.stg.lax.gnmedia.net",
  	}

## app-mgmt-prd
        common::nfsromount { "/mnt/crowdignite/app1v-mgmt.ci.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_log/app1v-mgmt.ci.prd.lax.gnmedia.net",
  	}

        common::nfsromount { "/mnt/crowdignite/app2v-mgmt.ci.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1b_ci_lax_prd_app_log/app2v-mgmt.ci.prd.lax.gnmedia.net",
  	}

## app-mgmt-stg
        common::nfsromount { "/mnt/crowdignite/app1v-mgmt.ci.stg.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.stg.lax.gnmedia.net:/vol/nac1a_ci_lax_stg_app_log/app1v-mgmt.ci.stg.lax.gnmedia.net",
  	}


### Crowdignite data volumes
## app-ci-prd
        common::nfsromount { "/mnt/crowdignite/data/app1v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_data/app1v-ci.ci.prd.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/crowdignite/data/app2v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1b_ci_lax_prd_app_data/app2v-ci.ci.prd.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/crowdignite/data/app3v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_data/app3v-ci.ci.prd.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/crowdignite/data/app4v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1b_ci_lax_prd_app_data/app4v-ci.ci.prd.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/crowdignite/data/app5v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_data/app5v-ci.ci.prd.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/crowdignite/data/app6v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1b_ci_lax_prd_app_data/app6v-ci.ci.prd.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/crowdignite/data/app7v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_data/app7v-ci.ci.prd.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/crowdignite/data/app8v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1b_ci_lax_prd_app_data/app8v-ci.ci.prd.lax.gnmedia.net",
        }

## app-ci-stg
        common::nfsromount { "/mnt/crowdignite/data/app1v-ci.ci.stg.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.stg.lax.gnmedia.net:/vol/nac1a_ci_lax_stg_app_data/app1v-ci.ci.stg.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/crowdignite/data/app2v-ci.ci.stg.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.stg.lax.gnmedia.net:/vol/nac1b_ci_lax_stg_app_data/app2v-ci.ci.stg.lax.gnmedia.net",
        }

## app-vw-prd
        common::nfsromount { "/mnt/crowdignite/data/app1v-vw.ci.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_data/app1v-vw.ci.prd.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/crowdignite/data/app2v-vw.ci.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1b_ci_lax_prd_app_data/app2v-vw.ci.prd.lax.gnmedia.net",
        }

## app-vw-stg
        common::nfsromount { "/mnt/crowdignite/data/app1v-vw.ci.stg.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.stg.lax.gnmedia.net:/vol/nac1a_ci_lax_stg_app_data/app1v-vw.ci.stg.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/crowdignite/data/app2v-vw.ci.stg.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.stg.lax.gnmedia.net:/vol/nac1b_ci_lax_stg_app_data/app2v-vw.ci.stg.lax.gnmedia.net",
        }

## ngx-ci-prd
        common::nfsromount { "/mnt/crowdignite/data/ngx1v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_data/ngx1v-ci.ci.prd.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/crowdignite/data/ngx2v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1b_ci_lax_prd_app_data/ngx2v-ci.ci.prd.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/crowdignite/data/ngx3v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_data/ngx3v-ci.ci.prd.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/crowdignite/data/ngx4v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1b_ci_lax_prd_app_data/ngx4v-ci.ci.prd.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/crowdignite/data/ngx5v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_data/ngx5v-ci.ci.prd.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/crowdignite/data/ngx6v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1b_ci_lax_prd_app_data/ngx6v-ci.ci.prd.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/crowdignite/data/ngx7v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_data/ngx7v-ci.ci.prd.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/crowdignite/data/ngx8v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1b_ci_lax_prd_app_data/ngx8v-ci.ci.prd.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/crowdignite/data/ngx9v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1a_ci_lax_prd_app_data/ngx9v-ci.ci.prd.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/crowdignite/data/ngx10v-ci.ci.prd.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.prd.lax.gnmedia.net:/vol/nac1b_ci_lax_prd_app_data/ngx10v-ci.ci.prd.lax.gnmedia.net",
        }

## ngx-ci-stg
        common::nfsromount { "/mnt/crowdignite/data/ngx1v-ci.ci.stg.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.stg.lax.gnmedia.net:/vol/nac1a_ci_lax_stg_app_data/ngx1v-ci.ci.stg.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/crowdignite/data/ngx2v-ci.ci.stg.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.stg.lax.gnmedia.net:/vol/nac1b_ci_lax_stg_app_data/ngx2v-ci.ci.stg.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/crowdignite/data/ngx3v-ci.ci.stg.lax.gnmedia.net":
                 device  => "nfsA-netapp1.ci.stg.lax.gnmedia.net:/vol/nac1a_ci_lax_stg_app_data/ngx3v-ci.ci.stg.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/crowdignite/data/ngx4v-ci.ci.stg.lax.gnmedia.net":
                 device  => "nfsB-netapp1.ci.stg.lax.gnmedia.net:/vol/nac1b_ci_lax_stg_app_data/ngx4v-ci.ci.stg.lax.gnmedia.net",
        }


###################################################################################################
###### Springboard ################################################################################
###################################################################################################
        common::nfsromount { "/mnt/springboard/stg/app1v-cms.sbv.stg.lax.gnmedia.net":
                device => "nfsA-netapp1.sbv.stg.lax.gnmedia.net:/vol/nac1a_sbv_lax_stg_app_log/app1v-cms.sbv.stg.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/stg/app1v-media.sbv.stg.lax.gnmedia.net":
                device => "nfsA-netapp1.sbv.stg.lax.gnmedia.net:/vol/nac1a_sbv_lax_stg_app_log/app1v-media.sbv.stg.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/stg/app1v-stats-cms.sbv.stg.lax.gnmedia.net":
                device => "nfsA-netapp1.sbv.stg.lax.gnmedia.net:/vol/nac1a_sbv_lax_stg_app_log/app1v-stats-cms.sbv.stg.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/stg/app1v-yourls.sbv.stg.lax.gnmedia.net":
                device => "nfsA-netapp1.sbv.stg.lax.gnmedia.net:/vol/nac1a_sbv_lax_stg_app_log/app1v-yourls.sbv.stg.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/stg/app2v-cms.sbv.stg.lax.gnmedia.net":
                device => "nfsB-netapp1.sbv.stg.lax.gnmedia.net:/vol/nac1b_sbv_lax_stg_app_log/app2v-cms.sbv.stg.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/stg/app2v-media.sbv.stg.lax.gnmedia.net":
                device => "nfsB-netapp1.sbv.stg.lax.gnmedia.net:/vol/nac1b_sbv_lax_stg_app_log/app2v-media.sbv.stg.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/stg/app2v-stats-cms.sbv.stg.lax.gnmedia.net":
                device => "nfsB-netapp1.sbv.stg.lax.gnmedia.net:/vol/nac1b_sbv_lax_stg_app_log/app2v-stats-cms.sbv.stg.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/stg/app2v-yourls.sbv.stg.lax.gnmedia.net":
                device => "nfsB-netapp1.sbv.stg.lax.gnmedia.net:/vol/nac1b_sbv_lax_stg_app_log/app2v-yourls.sbv.stg.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/stg/app3v-cms.sbv.stg.lax.gnmedia.net":
                device => "nfsA-netapp1.sbv.stg.lax.gnmedia.net:/vol/nac1a_sbv_lax_stg_app_log/app3v-cms.sbv.stg.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/stg/app3v-media.sbv.stg.lax.gnmedia.net":
                device => "nfsA-netapp1.sbv.stg.lax.gnmedia.net:/vol/nac1a_sbv_lax_stg_app_log/app3v-media.sbv.stg.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/stg/app3v-stats-cms.sbv.stg.lax.gnmedia.net":
                device => "nfsA-netapp1.sbv.stg.lax.gnmedia.net:/vol/nac1a_sbv_lax_stg_app_log/app3v-stats-cms.sbv.stg.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/stg/app4v-cms.sbv.stg.lax.gnmedia.net":
                device => "nfsB-netapp1.sbv.stg.lax.gnmedia.net:/vol/nac1b_sbv_lax_stg_app_log/app4v-cms.sbv.stg.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/stg/app4v-media.sbv.stg.lax.gnmedia.net":
                device => "nfsB-netapp1.sbv.stg.lax.gnmedia.net:/vol/nac1b_sbv_lax_stg_app_log/app4v-media.sbv.stg.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/stg/app4v-stats-cms.sbv.stg.lax.gnmedia.net":
                device => "nfsB-netapp1.sbv.stg.lax.gnmedia.net:/vol/nac1b_sbv_lax_stg_app_log/app4v-stats-cms.sbv.stg.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/stg/app5v-stats-cms.sbv.stg.lax.gnmedia.net":
                device => "nfsA-netapp1.sbv.stg.lax.gnmedia.net:/vol/nac1a_sbv_lax_stg_app_log/app5v-stats-cms.sbv.stg.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/stg/app6v-stats-cms.sbv.stg.lax.gnmedia.net":
                device => "nfsB-netapp1.sbv.stg.lax.gnmedia.net:/vol/nac1b_sbv_lax_stg_app_log/app6v-stats-cms.sbv.stg.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/stg/cms-logs":
                device => "nfsA-netapp1.sbv.stg.lax.gnmedia.net:/vol/nac1a_sbv_lax_stg_app_shared/cms-shared/cms-logs",
        }
        common::nfsromount { "/mnt/springboard/prd/app1v-cms.sbv.prd.lax.gnmedia.net":
                device => "nfsA-netapp1.sbv.prd.lax.gnmedia.net:/vol/nac1a_sbv_lax_prd_app_log/app1v-cms.sbv.prd.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/prd/app1v-gweb.sbv.prd.lax.gnmedia.net":
                device => "nfsA-netapp1.sbv.prd.lax.gnmedia.net:/vol/nac1a_sbv_lax_prd_app_log/app1v-gweb.sbv.prd.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/prd/app1v-media.sbv.prd.lax.gnmedia.net":
                device => "nfsA-netapp1.sbv.prd.lax.gnmedia.net:/vol/nac1a_sbv_lax_prd_app_log/app1v-media.sbv.prd.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/prd/app1v-preroll.sbv.prd.lax.gnmedia.net":
                device => "nfsA-netapp1.sbv.prd.lax.gnmedia.net:/vol/nac1a_sbv_lax_prd_app_log/app1v-preroll.sbv.prd.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/prd/app1v-stats-cms.sbv.prd.lax.gnmedia.net":
                device => "nfsA-netapp1.sbv.prd.lax.gnmedia.net:/vol/nac1a_sbv_lax_prd_app_log/app1v-stats-cms.sbv.prd.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/prd/app1v-yourls.sbv.prd.lax.gnmedia.net":
                device => "nfsA-netapp1.sbv.prd.lax.gnmedia.net:/vol/nac1a_sbv_lax_prd_app_log/app1v-yourls.sbv.prd.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/prd/app2v-cms.sbv.prd.lax.gnmedia.net":
                device => "nfsB-netapp1.sbv.prd.lax.gnmedia.net:/vol/nac1b_sbv_lax_prd_app_log/app2v-cms.sbv.prd.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/prd/app2v-media.sbv.prd.lax.gnmedia.net":
                device => "nfsB-netapp1.sbv.prd.lax.gnmedia.net:/vol/nac1b_sbv_lax_prd_app_log/app2v-media.sbv.prd.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/prd/app2v-preroll.sbv.prd.lax.gnmedia.net":
                device => "nfsB-netapp1.sbv.prd.lax.gnmedia.net:/vol/nac1b_sbv_lax_prd_app_log/app2v-preroll.sbv.prd.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/prd/app2v-stats-cms.sbv.prd.lax.gnmedia.net":
                device => "nfsB-netapp1.sbv.prd.lax.gnmedia.net:/vol/nac1b_sbv_lax_prd_app_log/app2v-stats-cms.sbv.prd.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/prd/app2v-yourls.sbv.prd.lax.gnmedia.net":
                device => "nfsB-netapp1.sbv.prd.lax.gnmedia.net:/vol/nac1b_sbv_lax_prd_app_log/app2v-yourls.sbv.prd.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/prd/app3v-cms.sbv.prd.lax.gnmedia.net":
                device => "nfsA-netapp1.sbv.prd.lax.gnmedia.net:/vol/nac1a_sbv_lax_prd_app_log/app3v-cms.sbv.prd.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/prd/app3v-media.sbv.prd.lax.gnmedia.net":
                device => "nfsA-netapp1.sbv.prd.lax.gnmedia.net:/vol/nac1a_sbv_lax_prd_app_log/app3v-media.sbv.prd.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/prd/app3v-stats-cms.sbv.prd.lax.gnmedia.net":
                device => "nfsA-netapp1.sbv.prd.lax.gnmedia.net:/vol/nac1a_sbv_lax_prd_app_log/app3v-stats-cms.sbv.prd.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/prd/app4v-cms.sbv.prd.lax.gnmedia.net":
                device => "nfsB-netapp1.sbv.prd.lax.gnmedia.net:/vol/nac1b_sbv_lax_prd_app_log/app4v-cms.sbv.prd.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/prd/app4v-media.sbv.prd.lax.gnmedia.net":
                device => "nfsB-netapp1.sbv.prd.lax.gnmedia.net:/vol/nac1b_sbv_lax_prd_app_log/app4v-media.sbv.prd.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/prd/app4v-stats-cms.sbv.prd.lax.gnmedia.net":
                device => "nfsB-netapp1.sbv.prd.lax.gnmedia.net:/vol/nac1b_sbv_lax_prd_app_log/app4v-stats-cms.sbv.prd.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/prd/app5v-stats-cms.sbv.prd.lax.gnmedia.net":
                device => "nfsA-netapp1.sbv.prd.lax.gnmedia.net:/vol/nac1a_sbv_lax_prd_app_log/app5v-stats-cms.sbv.prd.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/prd/app6v-stats-cms.sbv.prd.lax.gnmedia.net":
                device => "nfsB-netapp1.sbv.prd.lax.gnmedia.net:/vol/nac1b_sbv_lax_prd_app_log/app6v-stats-cms.sbv.prd.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/springboard/prd/cms-logs":
                device => "nfsA-netapp1.sbv.prd.lax.gnmedia.net:/vol/nac1a_sbv_lax_prd_app_shared/cms-shared/cms-logs",
        }
###################################################################################################
###### Origin      ################################################################################
###################################################################################################

        common::nfsromount { "/mnt/origin/dev/app1v-origin.og.dev.lax.gnmedia.net":
            device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_dev_app_log/app1v-origin.og.dev.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/origin/stg/app1v-origin.og.stg.lax.gnmedia.net":
            device  => "nfsA-netapp1.og.stg.lax.gnmedia.net:/vol/nac1a_og_lax_stg_app_log/app1v-origin.og.stg.lax.gnmedia.net",
        }  

        common::nfsromount { "/mnt/origin/stg/app2v-origin.og.stg.lax.gnmedia.net":
            device  => "nfsB-netapp1.og.stg.lax.gnmedia.net:/vol/nac1b_og_lax_stg_app_log/app2v-origin.og.stg.lax.gnmedia.net",
        }  

        common::nfsromount { "/mnt/origin/stg/app1v-mgmt.og.stg.lax.gnmedia.net":
            device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_stg_app_log/app1v-mgmt.og.stg.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/origin/prd/app1v-origin.og.prd.lax.gnmedia.net":
            device  => "nfsA-netapp1.og.prd.lax.gnmedia.net:/vol/nac1a_og_lax_prd_app_log/app1v-origin.og.prd.lax.gnmedia.net",
        }  

        common::nfsromount { "/mnt/origin/prd/app2v-origin.og.prd.lax.gnmedia.net":
            device  => "nfsB-netapp1.og.prd.lax.gnmedia.net:/vol/nac1b_og_lax_prd_app_log/app2v-origin.og.prd.lax.gnmedia.net",
        }  

        common::nfsromount { "/mnt/origin/prd/app1v-mgmt.og.prd.lax.gnmedia.net":
            device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_prd_app_log/app1v-mgmt.og.prd.lax.gnmedia.net",
        }

        common::nfsromount { "/mnt/origin/prd/app2v-mgmt.og.prd.lax.gnmedia.net":
            device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_og_lax_prd_app_log/app2v-mgmt.og.prd.lax.gnmedia.net",
        }

###################################################################################################
###### TechPratfall ################################################################################
###################################################################################################
        common::nfsromount { "/mnt/techplatform/puppet/app5v-puppet.tp.prd.lax.gnmedia.net":
                device => "nfsB-netapp1.tp.prd.lax.gnmedia.net:/vol/nac1b_tp_lax_prd_app_log/app5v-puppet.tp.prd.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/techplatform/puppet/app6v-puppet.tp.prd.lax.gnmedia.net":
                device => "nfsB-netapp1.tp.prd.lax.gnmedia.net:/vol/nac1b_tp_lax_prd_app_log/app6v-puppet.tp.prd.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/techplatform/puppet/app7v-puppet.tp.prd.lax.gnmedia.net":
                device => "nfsA-netapp1.tp.prd.lax.gnmedia.net:/vol/nac1a_tp_lax_prd_app_log/app7v-puppet.tp.prd.lax.gnmedia.net",
        }
        common::nfsromount { "/mnt/techplatform/puppet/app8v-puppet.tp.prd.lax.gnmedia.net":
                device => "nfsB-netapp1.tp.prd.lax.gnmedia.net:/vol/nac1b_tp_lax_prd_app_log/app8v-puppet.tp.prd.lax.gnmedia.net",
        }

###################################################################################################
###### SalesIntegration  ##########################################################################
###################################################################################################
    common::nfsmount { "/mnt/salesintegration/prd":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_si_lax_prd_app_log",
    }
    common::nfsmount { "/mnt/salesintegration/stg":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_si_lax_stg_app_log",
    }
}
