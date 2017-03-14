node 'sql1v-56-tags.ap.stg.lax.gnmedia.net' {
  include base
  $project="adops"
  class {"mysqld56": template=>"56-tags.ap.stg.lax-slave"}

  include newrelic
  include newrelic::params
  include newrelic::sysmond
  include newrelic::nfsiostat
  include newrelic::mysql

  common::nfsmount { "/sql/data":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_56_tags_ap_stg_lax_data",
  }

  common::nfsmount { "/sql/binlog":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_56_tags_ap_stg_lax_binlog",
   }

  common::nfsmount { "/sql/log":
    device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_stg_sql_log/sql1v-56-tags.ap.stg.lax.gnmedia.net",
  }
}
