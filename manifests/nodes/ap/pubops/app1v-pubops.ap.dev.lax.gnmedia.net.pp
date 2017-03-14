node 'app1v-pubops.ap.dev.lax.gnmedia.net' {
  include base
  $project='adops'

  include ap::app::pubops
  include ap::app::pubops::dev

  include newrelic
  include newrelic::params
  include newrelic::nfsiostat
  include newrelic::sysmond

  package {'git':
    ensure => installed,
  }

  httpd::virtual_host {"dev.pubops.evolvemediacorp.com": monitor => false}

  common::nfsmount { "/app/shared":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/pubops-shared",
  }

  common::nfsmount { "/app/log":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_log/app1v-pubops.ap.dev.lax.gnmedia.net",
  }

  common::nfsromount { "/app/software":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/ap-software-dev",
  }

}
