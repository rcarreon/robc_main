node 'uid2v-ddurand.tp.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
  include base
  include yum::ius
  include puppet_agent::uid
  include rsyslog::locallogs

  package { ['tmux']:
    ensure => installed
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

  package { [ 'jdk1.8.0_45.x86_64']:
      ensure => installed,
  }

  include spark
  include spark::install
  include spark::config 

  include scala::install
  include scala::config 

  include hadoop
  include hadoop::client_config

  class {"hadoop::jdbc_mysql":
        path => "/opt/spark/lib",
    }

  include pixel::base

}
