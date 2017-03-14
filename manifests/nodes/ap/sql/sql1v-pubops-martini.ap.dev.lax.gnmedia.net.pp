node 'sql1v-pubops-martini.ap.dev.lax.gnmedia.net' {
  include base
  $project='adops'

  class {'mysqld56': template=>'pubops-martini.ap.dev.lax-standalone'}

  include newrelic
  include newrelic::params
  include newrelic::sysmond
  include newrelic::nfsiostat
  include newrelic::mysql

  package { ['percona-toolkit', 'tmux']:
    ensure => installed,
  }

  common::nfsmount { '/sql/data':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_martini_ap_dev_lax_data',
  }

  common::nfsmount { '/sql/binlog':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_martini_ap_dev_lax_binlog',
  }

  common::nfsmount { '/sql/log':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1b_ap_lax_dev_sql_log/sql1v-pubops-martini.ap.dev.lax.gnmedia.net',
  }
}
