node 'uid1v-sdejean.tp.dev.lax.gnmedia.net' {
  include base
  $project="admin"
  # class {"mysqld56": template=>"sdejean.ap.dev.lax-standalone"}
  include puppet_agent::uid
  include yum::mariadb::wildwest
  include yum::mysql5627

  include newrelic
  include newrelic::params
  include newrelic::sysmond
  include newrelic::nfsiostat

  include hadoop::cluster

  package { [ 'git', 'subversion', 'python-pip' ]:
    ensure => installed,
  }

  common::nfsmount { "/sql/data":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_sdejean_tp_dev_lax_data",
  }

  common::nfsmount { "/sql/binlog":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_sdejean_tp_dev_lax_binlog",
  }

  common::nfsmount { "/sql/log":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_sql_log/uid1v-sdejean.tp.dev.lax.gnmedia.net",
  }

}
