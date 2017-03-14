node 'app1v-stream.ap.dev.lax.gnmedia.net' {
  include base
  $project='adops'
  include common::app
  include httpd

  include adops::rbenv
  include ap::app::adoperations
  include ap::app::adoperations::dev

  include newrelic
  include newrelic::params
  include newrelic::nfsiostat
  include newrelic::sysmond

  package { ['php-pear-Net_GeoIP', 'GeoIP']:
    ensure => present,
  }

  common::nfsmount { '/app/shared':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/adops-new-shared',
  }

  common::nfsmount { '/app/log':
    device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_dev_app_log/app1v-stream.ap.dev.lax.gnmedia.net',
  }

  common::nfsmount { '/app/ugc':
    device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_dev_app_ugc',
  }

  common::nfsromount { '/app/software':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/ap-software-dev',
  }

  # adops-api
  httpd::virtual_host {'dev.adops.evolvemediallc.com': uri => '/'}
  httpd::virtual_host {'dev.adops-api.evolvemediallc.com': uri => '/'}


  # GeoIP Config stuff
  class { 'ap::app::geoip': rails_env => 'development' }
  class { 'ap::app::geoip::config':
    config_path => '/app/shared/docroots/geoip.evolvemediallc.com/shared/config'
  }
  httpd::virtual_host {'dev.geoip.evolvemediallc.com': uri => '/'}

  cron { 'geoip_update':
    ensure  => absent,
    user    => 'adops-deploy',
    minute  => '12',
    hour    => '23',
    weekday => '3',
    command => '/usr/bin/geoipupdate -f /app/shared/docroots/geoip.evolvemediallc.com/shared/config/GeoIP.conf -d /app/shared/docroots/geoip.evolvemediallc.com/shared/data',
  }

}
