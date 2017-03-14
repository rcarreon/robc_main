node 'sql2v-bd.og.prd.lax.gnmedia.net' {
  include base
  $project="origin"

  class {'mysqld56': template=>'bd.og.prd.lax-master', sqlclass=>'supported'}

  common::nfsmount { "/sql/log":
    device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_og_lax_prd_sql_log/sql2v-bd.og.prd.lax.gnmedia.net"
  }

  common::nfsmount { "/sql/data":
    device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql2v_bd_og_prd_lax_data"
  }

  common::nfsmount { "/sql/binlog":
    device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql2v_bd_og_prd_lax_binlog"
  }

  include newrelic
  include newrelic::params
  include newrelic::sysmond
  include newrelic::nfsiostat
  include newrelic::mysql
}
