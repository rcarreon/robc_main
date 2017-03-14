node 'sql1v-56-piwik.si.prd.lax.gnmedia.net' {
  include base
  $project="piwik"
  class {"mysqld56": template=>"56-piwik.si.prd.lax-standalone"}
  common::nfsmount { '/sql/log':
    device => 'nfsA-netapp1.tp.prd.lax.gnmedia.net:/vol/nac1a_si_lax_prd_app_log/sql1v-56-piwik.si.prd.lax.gnmedia.net',
  }

  common::nfsmount { '/sql/binlog':
    device => 'nfsA-netapp1.tp.prd.lax.gnmedia.net:/vol/nac1a_sql1v_56_piwik_si_prd_lax_binlog',
  }

  common::nfsmount { '/sql/data':
    device => 'nfsA-netapp1.tp.prd.lax.gnmedia.net:/vol/nac1a_sql1v_56_piwik_si_prd_lax_data',
  }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
