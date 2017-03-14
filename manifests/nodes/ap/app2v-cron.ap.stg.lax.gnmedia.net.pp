node 'app2v-cron.ap.stg.lax.gnmedia.net' {
  include base
  $project='adops'
  include common::app

  include newrelic
  include newrelic::params
  include newrelic::nfsiostat
  include newrelic::sysmond

  include yum::adopsgem::beta
  include adops::rbenv
  include ap::app::workers
  include ap::app::workers::payout_cache
  include ap::app::workers::payout_cache::stg

  include ap::app::workers::janitor
  include ap::app::workers::janitor::dev

  common::nfsmount { "/app/shared":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_stg_app_shared/adops-shared",
  }

  common::nfsmount { "/app/ugc":
    device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_stg_app_ugc/",
    options => "nfsvers=3,noatime,rw,rsize=32768,wsize=32768,hard,intr,tcp,noexec,nosuid",
  }

  common::nfsmount { "/app/log":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_stg_app_log/app2v-cron.ap.stg.lax.gnmedia.net",
  }

  common::nfsromount { "/app/software":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_stg_app_shared/ap-software-stg",
  }

  $redis_password = decrypt("bluT9KCnQ9rTa/xmWIY5bdWPCwb4+kSjYf2+UbITABM=")
  redis::store { "adops": }
}
