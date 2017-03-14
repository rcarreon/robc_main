node 'app2v-geoip.ap.prd.lax.gnmedia.net' {
  include base
  $project='adops'
  include common::app
  include httpd
  include php

  package { ['php-pear-Net_GeoIP','GeoIP']:
    ensure => present,
  }

  httpd::virtual_host {'geo.gorillanation.com':
    uri     => '/geo.php',
    expect  => 'gn_country',
    ensure  => 'absent',
  }

  common::nfsmount { "/app/shared":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_shared/geoip-shared",
    options => "rw,noatime,nfsvers=3,rsize=32768,wsize=32768,hard,intr,tcp,actimeo=1000"
  }

  common::nfsmount { "/app/log":
    device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_prd_app_log/app2v-geoip.ap.prd.lax.gnmedia.net",
  }
  
  common::nfsromount { "/app/software":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_shared/ap-software-prd",
  }

  # New GeoIP Config stuff
  class { 'ap::app::geoip': rails_env => 'production' }
  httpd::virtual_host {'geoip.evolvemediallc.com':
    uri     => '/geo',
    expect  => 'gn_country',
  }

}
