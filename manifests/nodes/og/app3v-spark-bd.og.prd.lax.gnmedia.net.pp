node 'app3v-spark-bd.og.prd.lax.gnmedia.net' {
  include base
  cron::monitor { 'important': warntime => 30, crittime => 60 }

  package { [ 'jdk1.8.0_45.x86_64', 'python-pip', 'mysql-connector-python']:
      ensure => installed,
  }
  
  sudo::install_template { 'dba-root': }
  $parser_installed = '/app/data/hadoop/WEBLOG_INSTALLED'

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

  common::nfsmount { "/app/log":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_prd_app_log/app3v-spark-bd.og.prd.lax.gnmedia.net",
  }

  common::nfsmount { "/app/data":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_prd_app_data/app3v-spark-bd.og.prd.lax.gnmedia.net",
  }

  class {'security::flume_nofile':
    hard_file_limit => 16384,
    soft_file_limit => 16384,
  }

  include newrelic
  include newrelic::params
  include newrelic::sysmond
  include newrelic::nfsiostat

  include hadoop
  include hadoop::client_config
  include hadoop::install_for_spark

  include spark
  include spark::install
  include spark::config 

  include scala::install
  include scala::config 

  include logrotate::spark
  
  class {"hadoop::jdbc_mysql":
        path => "/opt/spark/lib",
  }

  exec {'retrieve-weblog_parser':
    command => 'pip install apache-log-parser',
    user    => 'root',
    group   => 'root',
    unless  => "test -f ${parser_installed}",
  }    

  exec {'set-weblog-installed':
    command => "touch ${parser_installed}",
    user    => 'root',
    group   => 'root',
    creates => "${parser_installed}",
  }

}
