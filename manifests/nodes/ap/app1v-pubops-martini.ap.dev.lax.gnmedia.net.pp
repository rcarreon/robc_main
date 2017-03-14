node 'app1v-pubops-martini.ap.dev.lax.gnmedia.net' {
  include base
  $project='adops'
 
  include ap::app::pubops_martini
  include ap::app::pubops_martini::dev
  include sendmail::tarpit

  include newrelic
  include newrelic::params
  include newrelic::nfsiostat
  include newrelic::sysmond

  package {'git':
    ensure => installed,
  }

  common::nfsmount { '/app/shared':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/adops-new-shared',
  }

  common::nfsmount { '/app/log':
    device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_dev_app_log/app1v-pubops-martini.ap.dev.lax.gnmedia.net',
  }

  common::nfsmount { '/app/ugc':
    device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_dev_app_ugc',
  }

  common::nfsromount { '/app/software':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/ap-software-dev',
  }

  # pubops vhost
  httpd::virtual_host {'dev.pubops.affluentdigitalmediallc.com': uri => '/'}

}
