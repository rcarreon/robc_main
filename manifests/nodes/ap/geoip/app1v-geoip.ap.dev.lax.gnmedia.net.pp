node 'app1v-geoip.ap.dev.lax.gnmedia.net' {
  include base
  $project='adops'
  include common::app
  include httpd

  include newrelic
  include newrelic::params
  include newrelic::nfsiostat
  include newrelic::sysmond

  package { ['GeoIP']:
    ensure => present,
  }

  #httpd::virtual_host {'geo.gorillanation.com': uri => '/geo.php', expect => 'gn_country',}

  common::nfsmount { "/app/shared":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/geoip-shared",
    options => "rw,noatime,nfsvers=3,rsize=32768,wsize=32768,hard,intr,tcp,actimeo=1000"
  }

  common::nfsmount { "/app/log":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_log/app1v-geoip.ap.dev.lax.gnmedia.net",
  }

  common::nfsromount { "/app/software":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/ap-software-dev",
  }

  # GeoIP Config stuff
  class { 'ap::app::geoip': rails_env => 'development' }
  class { 'ap::app::geoip::config':
    config_path => '/app/shared/docroots/geoip.evolvemediallc.com/shared/config'
  }
  httpd::virtual_host {'dev.geoip.evolvemediallc.com':
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
