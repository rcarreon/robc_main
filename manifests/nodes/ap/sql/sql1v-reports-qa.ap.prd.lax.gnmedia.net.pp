node 'sql1v-reports-qa.ap.prd.lax.gnmedia.net' {
  include base
  $project='adops'
  class {'mysqld56': template=>'reports.ap.prd.lax-standalone'}

  include newrelic
  include newrelic::params
  include newrelic::sysmond
  include newrelic::nfsiostat
  include newrelic::mysql

  common::nfsmount { '/sql/data':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_reports_ap_prd_lax_data',
  }

  common::nfsmount { '/sql/binlog':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_reports_ap_prd_lax_binlog',
  }

  common::nfsmount { '/sql/log':
    device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_prd_sql_log/sql1v-reports-qa.ap.prd.lax.gnmedia.net',
  }
}
