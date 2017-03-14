node 'app2v-cron.ap.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
  include base
  $project='adops'
  include common::app

  include yum::adopsgem::live

  include adops::rbenv
  include ap::app::workers
  include ap::app::workers::payout_cache
  include ap::app::workers::payout_cache::prd

  common::nfsmount { '/app/shared':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_shared/adops-shared',
  }

  common::nfsmount { '/app/ugc':
    device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_prd_app_ugc/',
    options => 'nfsvers=3,noatime,rw,rsize=32768,wsize=32768,hard,intr,tcp,noexec,nosuid',
  }

  common::nfsmount { '/app/log':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_log/app2v-cron.ap.prd.lax.gnmedia.net',
  }

  common::nfsromount { '/app/software':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_shared/ap-software-prd',
  }

  ## NOTE:  This job must run *after* the data from DFP has been processed by
  ## process-report. We're moving the payoutcache job to run at 4:30 AM, with
  ## the belief that the DFP job will have been scheduled, returned, and
  ## processed by 4:15 or so.
  cron { 'PayoutCacheYesterday':
    ensure      => present,
    user        => 'adops-worker',
    command     => '/opt/adops/payout-cache/bin/payout-cache nightly',
    hour        => '4',
    minute      => '30',
  }

  cron { 'PayoutCachePrev3Months':
    ensure      => present,
    user        => 'adops-worker',
    command     => '/opt/adops/payout-cache/bin/payout-cache quarterly',
    hour        => '20',
    minute      => '0',
  }


}
