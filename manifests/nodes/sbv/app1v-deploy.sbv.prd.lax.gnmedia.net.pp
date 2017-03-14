node 'app1v-deploy.sbv.prd.lax.gnmedia.net' {
    include base
    $project="springboard"
    include common::app
    include httpd
    
    include pythondeployer::server

    class {"mysqld56": template=>"deploy.sbv.prd.lax-standalone"}

    httpd::virtual_host {'deploy.springboardplatform.com':}

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_prd_app_shared/deploy-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_prd_app_log/app1v-deploy.sbv.prd.lax.gnmedia.net",
    }

    common::nfsmount { "/sql/data":
        device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_app1v_deploy_sbv_prd_lax_data",
    }
    common::nfsmount { "/sql/binlog":
        device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_app1v_deploy_sbv_prd_lax_binlog",
    }
    common::nfsmount{ "/sql/log":
        device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sbv_lax_prd_sql_log/app1v-deploy.sbv.prd.lax.gnmedia.net",
    }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
