node 'app1v-geoip.ap.stg.lax.gnmedia.net' {
  include base
  $project='adops'
  include common::app
  include httpd
  include php

  include newrelic
  include newrelic::params
  include newrelic::nfsiostat
  include newrelic::sysmond

  package { ['php-pear-Net_GeoIP', 'GeoIP']:
      ensure => present,
  }

  httpd::virtual_host {'geo.gorillanation.com': uri => '/geo.php', expect => 'gn_country', ensure => 'absent'}

  common::nfsmount { "/app/shared":
      device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_stg_app_shared/geoip-shared",
  }

  common::nfsmount { "/app/log":
      device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_stg_app_log/app1v-geoip.ap.stg.lax.gnmedia.net",
  }

  common::nfsromount { "/app/software":
      device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_stg_app_shared/ap-software-stg",
  }

  # GeoIP Config stuff
  class { 'ap::app::geoip': rails_env => 'staging' }
  class { 'ap::app::geoip::config':
    config_path => '/app/shared/docroots/geoip.evolvemediallc.com/shared/config'
  }
  httpd::virtual_host {'stg.geoip.evolvemediallc.com':
    uri     => '/geo',
    expect  => 'gn_country',
  }

  cron { 'geoip_update':
    ensure  => present,
    user    => 'adops-deploy',
    minute  => '12',
    hour    => '23',
    weekday => '3',
    command => '/usr/bin/geoipupdate -f /app/shared/docroots/geoip.evolvemediallc.com/shared/config/GeoIP.conf -d /app/shared/docroots/geoip.evolvemediallc.com/shared/data',
  }
}
