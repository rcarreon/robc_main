node 'uid1v-ddurand.tp.dev.lax.gnmedia.net' {
  include newrelic
  include newrelic::params
  include newrelic::sysmond
  include newrelic::nfsiostat
  include base
  include yum::ius
  include puppet_agent::uid
  include rsyslog::locallogs

  package { [ 'jdk1.8.0_45.x86_64', 'python-pip', 'mysql-connector-python', 'tmux']:
      ensure => installed,
  }

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

  # hadoop stuff
  include hadoop
  include hadoop::install
  include hadoop::server_config
  include hadoop::newrelic
  include logrotate::hadoop

  include spark
  include spark::install
  include spark::config 

  include zookeeper::install  
}
