node 'app1v-bd.tp.stg.lax.gnmedia.net' {
  include base

  package { [ 'jdk1.8.0_45.x86_64', 'python-pip', 'mysql-connector-python']:
      ensure => installed,
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

  common::nfsmount { "/app/log":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_stg_app_log/app1v-bd.tp.stg.lax.gnmedia.net",
  }

  common::nfsmount { "/app/data":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_stg_app_data/app1v-bd.tp.stg.lax.gnmedia.net",
  }

  include newrelic
  include newrelic::params
  include newrelic::sysmond
  include newrelic::nfsiostat

  include spark
  include spark::install
  include spark::config 

  include scala::install
  include scala::config 

  include hadoop
  include hadoop::client_config

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

  file { '/usr/local/bin/pixel_etl.py':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0755',
    content => template('techplatform/spark/pixel_analytics.py.erb')
  }

  file { '/usr/local/bin/adunit_timespent_process.py':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0755',
    content => template('techplatform/spark/adunit_timespent_process.py.erb')
  }

  file { '/usr/local/bin/parse_apache_weblogs.py':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0755',
    content => template('techplatform/spark/parse_apache_weblogs.py.erb')
  }

}
