node 'app3v-origin.og.stg.lax.gnmedia.net' {
  include base
  $project="bigdata"
  $httpd='bcn'
  include httpd
  
  httpd::virtual_host {'stg.originplatform.com': monitor => false }
  sudo::install_template { 'dba-root': }

  common::nfsmount { "/app/shared":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_stg_app_shared/origin-shared",
  }

  common::nfsmount { "/app/log":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_stg_app_log/app3v-origin.og.stg.lax.gnmedia.net",
  }

  common::nfsmount { "/app/ugc":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_stg_app_ugc",
  }

  file { '/app/data':
    ensure  => directory,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0775',
  }

  package { [ 'jdk1.8.0_45.x86_64']:
    ensure => installed,
  }

  include newrelic
  include newrelic::sysmond
  include newrelic::nfsiostat

  include flume::base
  include flume::config
  include flume::install

  include hadoop
  include hadoop::client_config

  include pixel::base

}
