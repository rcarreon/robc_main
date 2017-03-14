node 'app1v-bcn-bd.og.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
  include base
  $project="bigdata"
  $httpd='bcn'
  include httpd
  httpd::virtual_host {'bcn.originplatform.com': }
  sudo::install_template { 'dba-root': }

  common::nfsmount { "/app/shared":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_prd_app_shared/origin-shared",
  }

  common::nfsmount { "/app/log":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_prd_app_log/app1v-origin.og.prd.lax.gnmedia.net",
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

  include flume::base
  include flume::config
  include flume::install

  include hadoop
  include hadoop::client_config

  include pixel::base

  # Every 10 minutes   
  cron {'flume_monit':    
    ensure  => 'present',   
    command => '/usr/bin/python /etc/apache-flume/flume_monit.py > /dev/null',    
    user    => 'root',    
    minute  => '*/30',    
    hour    => '*',   
    month   => '*',   
    weekday => '*',   
  }

  file { '/var/www/html/bcn.png':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('pixel/templates/bcn.png')
  }

}
