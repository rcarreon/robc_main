node 'app2v-hadoop-bd.tp.prd.lax.gnmedia.net' {
  include base
  include newrelic
  include newrelic::sysmond
  include newrelic::nfsiostat

  package { ['tmux']:
    ensure => installed
  }

  sudo::install_template { 'dba-root': }

  file { '/app/data':
    ensure  => directory,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0775',
  }

  file { '/app/log':
    ensure  => directory,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0775',
  }

  common::nfsmount { '/app/data':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_data/hadoop2',
  }

  common::nfsmount { '/app/log':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_log/app2v-hadoop-bd.tp.prd.lax.gnmedia.net',
  }

  common::nfsmount { '/app/shared':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_shared/hadoop-shared',
  }

  class {'security::flume_nofile':
    hard_file_limit => 16384,
    soft_file_limit => 16384,
  }
  
  # hadoop stuff
  include hadoop
  include hadoop::install
  include hadoop::server_config
  include hadoop::newrelic
  include logrotate::hadoop

  include spark
  include spark::install
  include spark::config 

  # CRON JOBS
  file { '/usr/local/bin/cron-hdfs-snapshot':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0755',
    content => template('techplatform/hadoop/cron-hdfs-snapshot')
  }->
  
  cron { 'hdfs-snapshots':
    ensure    => present,
    user      => 'hadoop',
    command   => '/usr/local/bin/cron-hdfs-snapshot >> /app/log/hadoop/hdfs-snapshot.log',
    hour      => '01',
    minute    => '00',
    require   => Exec['set-hadoop-installed'],
  }

}