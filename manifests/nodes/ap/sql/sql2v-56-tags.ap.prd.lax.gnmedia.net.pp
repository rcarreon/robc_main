node 'sql2v-56-tags.ap.prd.lax.gnmedia.net' {
  include base
  $project="adops"
  class {"mysqld56": template=>"56-tags.ap.prd.lax-slave"}

  include newrelic
  include newrelic::params
  include newrelic::sysmond
  include newrelic::nfsiostat
  include newrelic::mysql

  common::nfsmount { "/sql/data":
    device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql2v_56_tags_ap_prd_lax_data",
  }

  common::nfsmount { "/sql/binlog":
    device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql2v_56_tags_ap_prd_lax_binlog",
  }

  common::nfsmount { "/sql/log":
    device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_prd_sql_log/sql2v-56-tags.ap.prd.lax.gnmedia.net",
  }
}
