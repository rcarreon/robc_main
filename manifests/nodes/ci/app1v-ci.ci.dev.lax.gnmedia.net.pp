node 'app1v-ci.ci.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base


    nagios::service {"dev.crowdignite.com_rest_content_format_json":
        command   => 'check_json.pl!http://dev.crowdignite.com/rest/content?format=json&domain=0,5,6,11&type=popular&ranked=1&page=1&limit=12',
        notes_url => 'http://docs.gnmedia.net/wiki/Nagios-check_json',
    }   

    $env='stg'
    $httpd='crowdignite'
    $project='crowdignite'
    $script_path='crowdignite_engine'
    include crowdignite::app_ci_dev
    include yum::ius

    package { 'php54-mbstring': 
        ensure => 'installed'
    }

    common::nfsmount { '/app/shared':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_dev_app_shared/ci-shared',
    }

    common::nfsmount { '/app/log':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_dev_app_log/app1v-ci.ci.dev.lax.gnmedia.net',
    }

    common::nfsmount { '/app/tmp':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_dev_app_shared/app_ci_tmp',
    }

    common::nfsmount { '/app/data':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_dev_app_data/app1v-ci.ci.dev.lax.gnmedia.net',
    }

    ### UGC
    # this is a shared vol btw dev and stg, don't panic, it is the correct vol :)
    common::nfsmount { '/app/ugc':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ci_lax_stg_app_ugc_tmp/upload',
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

}
