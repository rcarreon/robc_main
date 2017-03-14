node 'uid1v-ssalazar.tp.dev.lax.gnmedia.net' {
    include base
    include puppet_agent::uid
    include common::app
    include httpd
    include subversion::client
    #include yum::remi
    include auth::mysql
    # include yum::mariadb::wildwest
    common::add_profiled { 'vaquita_pythonpath.sh': }
    class {"mysqld56": template=>"uid1v-ssalazar.tp.dev.lax-standalone"}
    # req'd by vhost.
    $project='admin'
    httpd::virtual_host { 'ssalazar.gnmedia.net': monitor => false, }

  package { [ 'perl-suidperl', 'mysql-connector-python', 'MySQL-python', 'python-argparse', 'python-apscheduler', 'python-pip', 'python-sqlalchemy', 'rnetapp', 'mod_wsgi', 'subversion', 'git' ]:
    ensure => installed,
  }

  common::nfsmount { '/sql/data':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_ssalazar_tp_dev_lax_data',
  }
 
 common::nfsmount { '/sql/binlog':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_ssalazar_tp_dev_lax_binlog',
  }

  common::nfsmount { '/sql/log':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_sql_log/uid1v-ssalazar.tp.dev.lax.gnmedia.net',
  }

#  cron { "toolshed_db_parser":
#    ensure  => present,
#    command => "date>>/app/log/toolshed_db_parser.log;curl http://ssalazar.gnmedia.net/toolshed/sqlps_populate_server_list>>/app/log/toolshed_db_parser.log",
#    user    => 'root',
#    hour    => 0,
#    minute  => 0,
#  }

  $vaquita_local_path  = '/app/shared/docroots/vaquita.gnmedia.net'
  $vaquita_config_path = '/etc/vaquita-backup/config.ini'

  $dev_scheduler_pass  = decrypt('enl4bE6Tr1mfczcy064+fw==')
  $dev_dbsource_pass   = decrypt('7c8uFm+agY//0SF4XLVHTQ==')
  $dev_dbtool_pass     = decrypt('p2PVKZZEju2pksJ27SG8tg==')
  $dev_webservice_pass = decrypt('jnvydXwHYm2B9WkoDeVd3g==')
  $dev_netapp_pass     = decrypt('psWZ/qTcYxNWHMVw7o9frw==')
  $dev_netapp_host     = '10.64.44.8'

  file { '/usr/local/bin/shadowcheck':
    owner   => root,
    group   => apache,
    mode    => '4550',
    source  => 'puppet:///modules/common/shadowcheck',
  }

  file { '/etc/sysconfig/vaquita-backup':
    ensure  => file,
    owner   => 'root',
    group   => 'mysql',
    mode    => '0640',
    content => template('techplatform/vaquita-backup/vaquita-sysconfig'),
  }
   
  file { '/etc/vaquita-backup':
    ensure => directory,
    owner  => 'mysql',
    group  => 'mysql',
    mode   => '0755',
  }
   
  file { '/etc/vaquita-backup/config.ini':
    ensure  => file,
    owner   => 'root',
    group   => 'mysql',
    mode    => '0640',
    content => template('techplatform/vaquita-backup/dev-config.ini'),
  }
   
  file { '/etc/vaquita-backup/backups.json':
    ensure  => file,
    owner   => 'root',
    group   => 'mysql',
    mode    => '0640',
    content => template('techplatform/vaquita-backup/dev-backups.json'),
  }
  
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
