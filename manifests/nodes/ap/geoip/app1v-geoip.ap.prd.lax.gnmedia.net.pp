node 'app1v-geoip.ap.prd.lax.gnmedia.net' {
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
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_log/app1v-geoip.ap.prd.lax.gnmedia.net",
  }
  
  common::nfsromount { "/app/software":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_shared/ap-software-prd",
  }

  # New GeoIP Config stuff
  class { 'ap::app::geoip': rails_env => 'production' }
  class { 'ap::app::geoip::config':
    config_path => '/app/shared/docroots/geoip.evolvemediallc.com/shared/config'
  }
  httpd::virtual_host {'geoip.evolvemediallc.com':
    uri     => '/geo',
    expect  => 'gn_country',
  }

  # Old
  $adops_GeoIP_License = decrypt('L0K3qxm/4u6FIVQ5sNvETA==')
  $adops_GeoIP_UserID = '32923'
  $adops_GeoIP_ProductID = '106'

  file { '/app/shared/docroots/geo.gorillanation.com/conf':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  file { ['/app/shared/docroots/geo.gorillanation.com/data']:
    ensure  => directory,
    owner   => 'deploy',
    group   => 'deploy',
    mode    => '0755',
  }

  file { '/app/shared/docroots/geo.gorillanation.com/conf/GeoIP.conf':
    ensure  => present,
    content => "LicenseKey ${adops_GeoIP_License}\nUserId ${adops_GeoIP_UserID}\nProductIds ${adops_GeoIP_ProductID}",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  cron { 'geoip_update':
    ensure  => present,
    user    => 'deploy',
    minute  => '16',
    hour    => '23',
    weekday => '3',
    command => '/usr/bin/geoipupdate -f /app/shared/docroots/geo.gorillanation.com/conf/GeoIP.conf -d /app/shared/docroots/geo.gorillanation.com/data',
  }

}
