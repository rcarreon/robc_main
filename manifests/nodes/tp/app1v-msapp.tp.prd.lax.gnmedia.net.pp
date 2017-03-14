node 'app1v-msapp.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
  include base
  include yum::ius
 
    common::nfsmount { "/app/shared/docroot":
          device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_ms_shared/app_www",
    }
    common::nfsmount { "/app/cron_app":
          device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_ms_shared/cron_app",
    }
    common::nfsmount { "/app/homes/pnanjo":
          device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_ms_shared/pnanjo_home",
    }
    common::nfsmount { "/app/homes/releng":
          device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_ms_shared/releng_home",
    }
    common::nfsmount { "/app/log":
          device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_ms_log/app1v-msapp.tp.prd.lax.gnmedia.net",
    }


}
