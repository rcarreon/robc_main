node 'uid3v-sdejean.tp.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
  include base
  $project='admin'
  include yum::mariadb::wildwest

  include hadoop::config
  #include hadoop::install

  include zookeeper::config
  include zookeeper::install

  common::nfsmount { '/sql/data':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_uid3v_sdejean_tp_dev_lax_data',
  }

  common::nfsmount { '/sql/binlog':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_uid3v_sdejean_tp_dev_lax_binlog',
  }

  common::nfsmount { '/sql/log':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_sql_log/uid3v-sdejean.tp.dev.lax.gnmedia.net',
  }
}
