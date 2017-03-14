node 'sql1v-bd.og.dev.lax.gnmedia.net' {
  include base
  $project="origin"

  include newrelic
  include newrelic::params
  include newrelic::sysmond
  include newrelic::nfsiostat
  include newrelic::mysql

  class {'mysqld56': template=>'bd.og.dev.lax-standalone', sqlclass=>'supported'}

  common::nfsmount { "/sql/log":
    device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_dev_sql_log/sql1v-bd.og.dev.lax.gnmedia.net"
  }

  common::nfsmount { "/sql/data":
    device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_bd_og_dev_lax_data"
  }

  common::nfsmount { "/sql/binlog":
    device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_bd_og_dev_lax_binlog"
  }
}
