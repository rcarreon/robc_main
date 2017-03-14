
class ap::app::workers::payout_cache {

  file {'/etc/workers':
    ensure  => directory,
    owner   => 'adops-worker',
    group   => 'adops-worker',
    mode    => '0640',
  }

  file {'/etc/workers/payout-cache':
    ensure  => directory,
    owner   => 'adops-worker',
    group   => 'adops-worker',
    mode    => '0640',
    require => File['/etc/workers']
  }

  file {'/app/log/workers/payout-cache':
    ensure  => directory,
    owner   => 'adops-worker',
    group   => 'adops-worker',
    mode    => '0644',
    require => File['/app/log/workers']
  }

  file {'/app/log/workers/payout-cache/payout-cache.log':
    ensure => file,
    owner   => 'adops-worker',
    group   => 'adops-worker',
    mode    => '0644',
    require => File['/app/log/workers/payout-cache']
  }

  $rbenv_path         = "/app/software/ruby/rbenv"
  $rbenv_ruby_version = "2.2.2-railsexpress"
  $rbenv_script_name  = "payout-cache"
  file {'/usr/local/bin/payout-cache.sh':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template('adops/rbenv-wrapper.sh.erb')
  }
}

class ap::app::workers::payout_cache::dev {
  $pc_env                   = 'development'
  $pc_log_level             = 'info'
  $pc_logfile               = '/app/log/workers/payout-cache/payout_cache.log'
  $pc_limit                 = 10000
  $pc_csv_dir               = '/tmp'
  $pc_db_main_database      = 'adops2_0_production'
  $pc_db_main_user          = 'ap_reports_w'
  $pc_db_main_pass          = decrypt('CwHtUr1PXEt3NX12LKXkvA==')
  $pc_db_main_host          = 'sql1v-56-adops.ap.dev.lax.gnmedia.net'
  $pc_db_reporting_database = 'ap_adops_reporting'
  $pc_db_reporting_user     = 'ap_reports_w'
  $pc_db_reporting_pass     = decrypt('CwHtUr1PXEt3NX12LKXkvA==')
  $pc_db_reporting_host     = 'sql1v-56-adops.ap.dev.lax.gnmedia.net'
  file {'/etc/workers/payout-cache/settings.yml':
    ensure  => file,
    owner   => 'adops-worker',
    group   => 'adops-worker',
    mode    => '0644',
    content => template('adops/ap_payout_cache-settings.yml.erb'),
    require => File['/etc/workers/payout-cache']
  }
}

class ap::app::workers::payout_cache::stg {

  $pc_env                   = 'staging'
  $pc_log_level             = 'info'
  $pc_logfile               = '/app/log/workers/payout-cache/payout_cache.log'
  $pc_limit                 = 10000
  $pc_csv_dir               = '/tmp'
  $pc_db_main_database      = 'adops2_0_production'
  $pc_db_main_user          = 'ap_reports_w'
  $pc_db_main_pass          = decrypt('NEWJanR4+WO0MbmxAMDsCQ==')
  $pc_db_main_host          = 'vip-sqlrw-adops.ap.stg.lax.gnmedia.net'
  $pc_db_reporting_database = 'ap_adops_reporting'
  $pc_db_reporting_user     = 'ap_reports_w'
  $pc_db_reporting_pass     = decrypt('NEWJanR4+WO0MbmxAMDsCQ==')
  $pc_db_reporting_host     = 'vip-sqlrw-adops.ap.stg.lax.gnmedia.net'
  file {'/etc/workers/payout-cache/settings.yml':
      ensure  => file,
      owner   => 'adops-worker',
      group   => 'adops-worker',
      mode    => '0644',
      content => template('adops/ap_payout_cache-settings.yml.erb'),
      require => File['/etc/workers/payout-cache']
    }
}

class ap::app::workers::payout_cache::prd {

  $pc_env                   = 'production'
  $pc_log_level             = 'info'
  $pc_logfile               = '/app/log/workers/payout-cache/payout_cache.log'
  $pc_limit                 = 10000
  $pc_csv_dir               = '/tmp'
  $pc_db_main_database      = 'adops2_0_production'
  $pc_db_main_user          = 'ap_reports_w'
  $pc_db_main_pass          = decrypt('5LoByC2OCCIUii3XQoXpkg==')
  $pc_db_main_host          = 'vip-sqlrw-adops.ap.prd.lax.gnmedia.net'
  $pc_db_reporting_database = 'ap_adops_reporting'
  $pc_db_reporting_user     = 'ap_reports_w'
  $pc_db_reporting_pass     = decrypt('5LoByC2OCCIUii3XQoXpkg==')
  $pc_db_reporting_host     = 'vip-sqlrw-adops.ap.prd.lax.gnmedia.net'
  file {'/etc/workers/payout-cache/settings.yml':
      ensure  => file,
      owner   => 'adops-worker',
      group   => 'adops-worker',
      mode    => '0644',
      content => template('adops/ap_payout_cache-settings.yml.erb'),
      require => File['/etc/workers/payout-cache']
    }
}

class ap::app::workers::payout_cache::reports_qa {

  $pc_env                   = 'production'
  $pc_log_level             = 'info'
  $pc_logfile               = '/app/log/workers/payout-cache/payout_cache.log'
  $pc_limit                 = 10000
  $pc_csv_dir               = '/tmp'
  $pc_db_main_database      = 'adops2_0_production'
  $pc_db_main_user          = 'ap_reports_w'
  $pc_db_main_pass          = decrypt('5LoByC2OCCIUii3XQoXpkg==')
  $pc_db_main_host          = 'sql1v-reports-qa.ap.prd.lax.gnmedia.net'
  $pc_db_reporting_database = 'ap_adops_reporting'
  $pc_db_reporting_user     = 'ap_reports_w'
  $pc_db_reporting_pass     = decrypt('5LoByC2OCCIUii3XQoXpkg==')
  $pc_db_reporting_host     = 'sql1v-reports-qa.ap.prd.lax.gnmedia.net'
  file {'/etc/workers/payout-cache/settings.yml':
      ensure  => file,
      owner   => 'adops-worker',
      group   => 'adops-worker',
      mode    => '0644',
      content => template('adops/ap_payout_cache-settings.yml.erb'),
      require => File['/etc/workers/payout-cache']
    }
}
