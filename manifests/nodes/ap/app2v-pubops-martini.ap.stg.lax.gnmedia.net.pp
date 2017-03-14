node 'app2v-pubops-martini.ap.stg.lax.gnmedia.net' {
  include base
  $project='adops'

  include ap::app::pubops_martini
  include ap::app::pubops_martini::stg

  include newrelic
  include newrelic::params
  include newrelic::nfsiostat
  include newrelic::sysmond

  package {'git':
    ensure => installed,
  }


  common::nfsmount { '/app/shared':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_stg_app_shared/pubops-shared',
  }

  common::nfsmount { '/app/log':
    device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_stg_app_log/app2v-pubops-martini.ap.stg.lax.gnmedia.net',
  }

  common::nfsmount { '/app/ugc':
    device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_stg_app_ugc',
  }

  common::nfsromount { '/app/software':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_stg_app_shared/ap-software-stg',
  }

  # pubops vhost
  httpd::virtual_host {'stg.pubops.affluentdigitalmediallc.com': uri => '/'}

}
