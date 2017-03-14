node 'sql2v-56-adops.ap.stg.lax.gnmedia.net' {
  include base
  $project="adops"
  class {"mysqld56": template=>"56-adops.ap.stg.lax-master"}

  include newrelic
  include newrelic::params
  include newrelic::sysmond
  include newrelic::nfsiostat
  include newrelic::mysql

  package { ["percona-toolkit", "tmux"]:
    ensure => installed,
  }

  common::nfsmount { "/sql/data":
    device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql2v_56_adops_ap_stg_lax_data",
  }

  common::nfsmount { "/sql/binlog":
    device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_sql2v_56_adops_ap_stg_lax_binlog",
  }

  common::nfsmount { "/sql/log":
    device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_stg_sql_log/sql2v-56-adops.ap.stg.lax.gnmedia.net",
  }
}
