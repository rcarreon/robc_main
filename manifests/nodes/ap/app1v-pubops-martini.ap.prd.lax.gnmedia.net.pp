node 'app1v-pubops-martini.ap.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
  include base
  $project='adops'

  include ap::app::pubops_martini
  include ap::app::pubops_martini::prd
  include yum::mysql5627
  package {'git':
    ensure => installed,
  }

  common::nfsmount { '/app/shared':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_shared/pubops-shared',
  }

  common::nfsmount { '/app/log':
    device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_prd_app_log/app1v-pubops-martini.ap.prd.lax.gnmedia.net',
  }

  common::nfsmount { '/app/ugc':
    device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_prd_app_ugc',
  }

  common::nfsromount { '/app/software':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_shared/ap-software-prd',
  }

  # pubops vhost
  httpd::virtual_host {'pubops.affluentdigitalmediallc.com': uri => '/'}

}
