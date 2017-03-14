node 'uid2v-sdejean.tp.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
  include base
  $project="admin"
  # class {"mysqld56": template=>"sdejean.ap.dev.lax-standalone"}
  include puppet_agent::uid
  include yum::mariadb::wildwest
  include yum::mysql5627

  common::nfsmount { "/sql/data":
    device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_uid1v_sdejean_tp_dev_lax_data",
  }

  common::nfsmount { "/sql/binlog":
    device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_uid1v_sdejean_tp_dev_lax_binlog",
  }

  common::nfsmount { "/sql/log":
    device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_tp_lax_dev_sql_log/uid2v-sdejean.tp.dev.lax.gnmedia.net",
  }

}
