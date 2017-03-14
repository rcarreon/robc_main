node 'app1v-reports-qa.ap.prd.lax.gnmedia.net' {
  include base
  $project='adops'
  #include adops::appdirs
  include adops::common
  include adops::packages
  include adops::packages::v3
  include adops::passenger4
  # include adops::rbenv
  #include adopsV3::appdirs
  #include adops::newrelic::apm
  #include adops::newrelic::sysmond
  include ap::app::workers
  include ap::app::workers::payout_cache
  include ap::app::workers::payout_cache::reports_qa

  include yum::mysql5627
  include yum::adopsgem::wildwest

  include newrelic
  include newrelic::params
  include newrelic::sysmond
  include newrelic::nfsiostat

  file {'/etc/httpd/conf.d/passenger-adops.conf':
    ensure => absent
  }

  file {'/etc/httpd/conf.d/passenger.conf':
    ensure => absent
  }

  # mounts
  common::nfsmount { '/app/shared':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_shared/adops-reports-qa-shared',
  }

  common::nfsmount { '/app/ugc':
    device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_prd_app_reports_ugc/',
    options => 'nfsvers=3,noatime,rw,rsize=32768,wsize=32768,hard,intr,tcp,noexec,nosuid',
  }

  common::nfsmount { '/app/log':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_log/app1v-reports-qa.ap.prd.lax.gnmedia.net',
  }

  common::nfsromount { '/app/software':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/ap-software-dev',
  }

  # For now we want to force users on /app/software's version of rbenv
  # - sdejean
  file { '/etc/profile.d/rbenv.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "export RBENV_ROOT='/app/software/ruby/rbenv'\nexport PATH=\"\${RBENV_ROOT}/bin:\${PATH}\"\neval \"$(rbenv init -)\"",
    require => Mount['/app/software'],
  }



  # Vhosts
  httpd::virtual_host {
    'adops-qa.gorillanation.com':
      uri     => '/sessions/login',
      expect  => 'forgot your password'
  }

  # newprod and cta pubops disabled on 5/13/2014
  #   httpd::virtual_host {"newprod.pubops.evolvemediacorp.com": uri => '/robots.txt', expect => 'User-agent'}
  #   httpd::virtual_host {"cta.pubops.evolvemediacorp.com": uri => '/robots.txt', expect => 'norobots'}
  # disabled around 2/2014
  #   httpd::virtual_host {"pubops-legacy.gorillanation.com": uri => '/sessions/login', expect => 'forgot your password'}
  # redirect vhost
  # httpd::virtual_host {"pubops.gorillanation.com": monitor => false}

  # adopsv2
  ## database.yml creds
  ### rw creds
  $user_adplatform_rw_prd = 'adops_w'
  $pw_adplatform_rw_prd = decrypt('wlXLHuKnGkYv2Hf/IUtzRw==')
  $host_adplatform_rw_prd = 'sql1v-reports-qa.ap.prd.lax.gnmedia.net'

  ### rw migration creds, can run ddl
  $user_ap_migration_rw_prd = 'adops_migrate_w'
  $pw_ap_migration_rw_prd = decrypt('tXzhao5YJJPeYvwcqDHhhndf0mXdSoabZyYJHLngteo=')

  ### ro creds
  $user_adplatform_ro_prd = 'adops_r'
  $pw_adplatform_ro_prd = decrypt('KpEUz0c8QdVuxgBzIoTnTg==')
  $host_adplatform_ro_prd = 'sql1v-reports-qa.ap.prd.lax.gnmedia.net'

  ### salesforce creds
  $user_adplatform_salesforce = 'admin@gorillanation.com'
  $pw_adplatform_salesforce = decrypt('Xx/IEq9KL83Y3MBmh2GCBA==')

  file {'/app/shared/docroots/adops.gorillanation.com/shared/config/database.yml':
    content => template('adops/database-prod.yml.erb'),
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
  }

  ## phpmailer settings
  $env_adplatform_emailer = 'prod'
  $user_adplatform_emailer = 'emailer_r'
  $pw_adplatform_emailer = decrypt('ftulqt3lX1t7HjQeFejMqQ==')
  $host_adplatform_emailer = 'sql1v-reports-qa.ap.prd.lax.gnmedia.net'

  file {'/app/shared/docroots/adops.gorillanation.com/shared/config/emailer_settings.ini':
    content => template('adops/emailer_settings.ini.erb'),
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
  }
  ## end phpmailer settings


  # Define The adops environment in adops_env, for use with cron rake tasks
  file {'/app/shared/docroots/adops.gorillanation.com/shared/config/adops_env':
    ensure  => file,
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
    mode    => '0644',
    content => 'production',
  }

  # New rake task wrapper script for invoking cronjobs via rake tasks.
  file {'/usr/local/bin/adops_rake.sh':
    ensure  => present,
    owner   => 'nobody',
    group   => 'nobody',
    mode    => '0544',
    content => template('adops/adops_rake.sh'),
  }

  #################
  ### Cron jobs ###
  #################

  ## PAYOUT CACHE
  ## NOTE:  This job must run *after* the data from DFP has been processed by
  ## process-report. We're moving the payoutcache job to run at 4:30 AM, with
  ## the belief that the DFP job will have been scheduled, returned, and
  ## processed by 4:15 or so.
  cron { 'PayoutCacheYesterday':
    ensure      => present,
    user        => 'adops-worker',
    command     => '/opt/adops/payout-cache/bin/payout-cache nightly',
    hour        => '4',
    minute      => '30',
  }

  cron { 'PayoutCachePrev3Months':
    ensure      => present,
    user        => 'adops-worker',
    command     => '/opt/adops/payout-cache/bin/payout-cache quarterly',
    hour        => '20',
    minute      => '0',
  }

  ## MASTER PAYOUTS
  cron { 'AdopsMasterPayoutReport':
    ensure  => absent,
    user    => 'apache',
    command => "cd /app/shared/docroots/adops.gorillanation.com/current && bundle exec /app/shared/docroots/adops.gorillanation.com/current/script/runner 'Cronjob::AdopsMasterPayoutReport.new.run!'",
    hour    => '*',
    minute  => '*/5',
  }

  # Pre-calculated master payout
  cron { 'SharedMasterPayout':
    ensure      => absent,
    user        => 'nobody',
    command     => "/usr/local/bin/adops_rake.sh 'payout_cache:shared_master_payout'",
    hour        => '01',
    minute      => '00',
    require     => File['/usr/local/bin/adops_rake.sh'],
  }

  ##############
  ### PubOps ###
  ##############

  ## APP DIRS
  file { '/app/shared/docroots/pubops.evolvemediacorp.com':
    ensure  => directory,
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
    mode    => '0755',
  } ->
  file { '/app/shared/docroots/pubops.evolvemediacorp.com/shared':
    ensure  => directory,
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
    mode    => '0755',
  }->
  file { '/app/shared/docroots/pubops.evolvemediacorp.com/shared/config':
    ensure  => directory,
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
    mode    => '0755',
  } ->
  file { '/app/shared/docroots/pubops.evolvemediacorp.com/releases':
    ensure  => directory,
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
    mode    => '0755',
  }

  ## LOG DIRS
  file { '/app/log/pubops':
    ensure  => directory,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
  }->
  file { '/app/log/pubops/nobody':
      ensure  => directory,
      mode    => '0755',
      owner   => 'nobody',
      group   => 'nobody',
      require => File['/app/log/pubops'],
  }->
  file { '/app/log/pubops/apache':
      ensure  => directory,
      mode    => '0755',
      owner   => 'apache',
      group   => 'apache',
      require => File['/app/log/pubops'],
  }->
  file { '/app/log/pubops/adops-deploy':
      ensure  => directory,
      mode    => '0755',
      owner   => 'adops-deploy',
      group   => 'adops-deploy',
      require => File['/app/log/pubops'],
  }
  # DB Credentials
  $env_app_pubops_webui_ro = 'production'
  $host_app_pubops_webui_ro = 'sql1v-reports-qa.ap.prd.lax.gnmedian.net'
  $user_app_pubops_webui_ro = 'pubops_webui_r'
  $pw_app_pubops_webui_ro = decrypt('Kdg2UowqH546tRrnrCBqUA==')

  # Secret Key Base
  $secret_key_env_pubops_webui = 'production'
  $secret_key_base_pubops_webui = decrypt('Cb4srBVW68UYh6dgPQhAADECuhk2JVPM8dqoJpVYIq2khotMAdJ96kRAAsAQj0VyKMGgAuHw5e80TSKJyvyzGJfr3af3zzAVDe2HocG/p0mhD6HpEmtZzi5TrF8qIqzeC0aKK9aNi2jPTaTU4MmUcWjnFVMK8sVXhODObjlduCWQJiZZ9lkuVf2rEhZbusRC')

  file {'/app/shared/docroots/pubops.evolvemediacorp.com/shared/config/database.yml':
    content => template('adops/app_pubops_webui_database.yml.erb'),
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
  }

  # Define The adops environment in adops_env, for use with cron rake tasks
  file {'/app/shared/docroots/pubops.evolvemediacorp.com/shared/config/pubops_webui_env':
    ensure  => file,
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
    mode    => '0644',
    content => 'production',
  }

  $jira_user_pubops_webui = 'pubopsapi'
  $jira_pass_pubops_webui = 'not-availble-yet'
  file { '/app/shared/docroots/pubops.evolvemediacorp.com/shared/config/secrets.yml':
    ensure  => file,
    content => template('adops/app_pubops_webui.secrets.yml.erb'),
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
    mode    => '0755',
    require => File['/app/shared/docroots/pubops.evolvemediacorp.com/shared/config'],
  }

  httpd::virtual_host {'pubops-qa.evolvemediacorp.com': }



}
