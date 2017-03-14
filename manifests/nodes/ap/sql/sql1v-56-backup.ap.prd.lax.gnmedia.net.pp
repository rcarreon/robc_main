node 'sql1v-56-backup.ap.prd.lax.gnmedia.net' {
  include base
  $project="adops"
  class {"mysqld56": template=>"56-backup.ap.prd.lax-slave"}

  include newrelic
  include newrelic::params
  include newrelic::sysmond
  include newrelic::nfsiostat
  include newrelic::mysql

  common::nfsmount { "/sql/data":
      device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_56_backup_ap_prd_lax_data",
  }

  common::nfsmount { "/sql/binlog":
      device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_sql1v_56_backup_ap_prd_lax_binlog",
  }

  common::nfsmount { "/sql/log":
      device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_prd_sql_log/sql1v-56-backup.ap.prd.lax.gnmedia.net",
  }

  common::nfsmount { "/sql/archive":
      device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_sql_archive",
  }

  ### DB Backups - Scripts ###
  file {"/usr/local/bin/db-backup-adops":
      owner   => "root",
      group   => "root",
      mode    => "754",
      content => template('adops/db-backup-adops'),
  }

  file {"/usr/local/bin/db-backup-prune-adops":
      owner   => "root",
      group   => "root",
      mode    => "754",
      content => template('adops/db-backup-prune-adops'),
  }
  
  ### DB Backups - Crons ###
  Cron {
      user => "root",
  }

  # Prune backups
  cron {"prune_adops_backups":
      command => '/usr/local/bin/db-backup-prune-adops',
      hour    => 09,
      minute  => 03,
      ensure  => "present",
  }
  
  ## Daily ##
  # adops2_0_production
  cron {"daily_adops2_0_production":
      command => '/usr/local/bin/db-backup-adops daily adops2_0_production',
      hour    => 10,
      minute  => 03,
      ensure  => "present",
  }
  # ap_adops_reporting
  cron {"daily_ap_adops_reporting":
      command => '/usr/local/bin/db-backup-adops daily ap_adops_reporting',
      hour    => 10,
      minute  => 33,
      ensure  => "absent",
  }
  # dart_scheduler
  cron {"daily_dart_scheduler":
      command => '/usr/local/bin/db-backup-adops daily dart_scheduler',
      hour    => 11,
      minute  => 03,
      ensure  => "present",
  }
  # salesforce_local
  cron {"daily_salesforce_local":
      command => '/usr/local/bin/db-backup-adops daily salesforce_local',
      hour    => 11,
      minute  => 33,
      ensure  => "present",
  }

  ## Weekly ##
  # adops2_0_production
  cron {"weekly_adops2_0_production":
      command => '/usr/local/bin/db-backup-adops weekly adops2_0_production',
      hour    => 12,
      minute  => 03,
      weekday => 06,
      ensure  => "present",
  }
  # ap_adops_reporting
  cron {"weekly_ap_adops_reporting":
      command => '/usr/local/bin/db-backup-adops weekly ap_adops_reporting',
      hour    => 12,
      minute  => 33,
      weekday => 06,
      ensure  => "present",
  }
  # adops2_0_production.payout_cache
  cron {"weekly_adops2_0_production_payout_cache":
      command => '/usr/local/bin/db-backup-adops weekly adops2_0_production payout_cache',
      hour    => 13,
      minute  => 03,
      weekday => 06,
      ensure  => "present",
  }
  # adops2_0_production.payout_cache_daily
  cron {"weekly_adops2_0_production_payout_cache_daily":
      command => '/usr/local/bin/db-backup-adops weekly adops2_0_production payout_cache_daily',
      hour    => 14,
      minute  => 03,
      weekday => 06,
      ensure  => "present",
  }
  # adops2_0_production.reports
  cron {"weekly_adops2_0_production_reports":
      command => '/usr/local/bin/db-backup-adops weekly adops2_0_production reports',
      hour    => 15,
      minute  => 33,
      weekday => 06,
      ensure  => "present",
  }
  # dart_scheduler
  cron {"weekly_dart_scheduler":
      command => '/usr/local/bin/db-backup-adops weekly dart_scheduler',
      hour    => 16,
      minute  => 33,
      weekday => 06,
      ensure  => "present",
  }
  # salesforce_local
  cron {"weekly_salesforce_local":
      command => '/usr/local/bin/db-backup-adops weekly salesforce_local',
      hour    => 16,
      minute  => 03,
      weekday => 06,
      ensure  => "present",
  }
}
