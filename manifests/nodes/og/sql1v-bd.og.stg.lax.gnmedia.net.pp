node 'sql1v-bd.og.stg.lax.gnmedia.net' {
  include base
  $project="origin"

  include newrelic
  include newrelic::params
  include newrelic::sysmond
  include newrelic::nfsiostat
  include newrelic::mysql

  class {'mysqld56': template=>'bd.og.stg.lax-standalone', sqlclass=>'supported'}

  common::nfsmount { "/sql/log":
    device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_stg_sql_log/sql1v-bd.og.stg.lax.gnmedia.net"
  }

  common::nfsmount { "/sql/data":
    device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_bd_og_stg_lax_data"
  }

  common::nfsmount { "/sql/binlog":
    device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_bd_og_stg_lax_binlog"
  }
}
