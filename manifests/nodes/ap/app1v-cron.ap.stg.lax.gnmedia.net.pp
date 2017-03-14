node 'app1v-cron.ap.stg.lax.gnmedia.net' {
    include base
    $project='adops'
    include adops::packages
    include adops::appdirs
    include adopsV3::appdirs
    include dfp::appdirs
    include adops::dfp_rtb_creds
    include ap::cron::gp
    include ap::cron::gp::stg
    include adops::rbenv
    include adops::common
    include php::adops
    include adops::devmail

    include adops::newrelic::apm

    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat

    package {'git':
      ensure => installed
    }

### MOUNTS

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_stg_app_shared/adops-shared",
    }

    common::nfsmount { "/app/ugc":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_stg_app_ugc/",
        options => "nfsvers=3,noatime,rw,rsize=32768,wsize=32768,hard,intr,tcp,noexec,nosuid",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_stg_app_log/app1v-cron.ap.stg.lax.gnmedia.net",
    }

    common::nfsromount { "/app/software":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_stg_app_shared/ap-software-stg",
    }

### PACKAGES

    package {['gcc','ruby-devel','GeoIP']:
            ensure => present,
    }

    # passwords
    $host_adops_cron_check_db='vip-sqlro-adops.ap.stg.lax.gnmedia.net'
    $payoutcheck_r=decrypt("OYbMjXK2lfT6HzmYcpmq5g==")

    # New populate payout cache script
    file {'/usr/local/bin/cron-payoutcache':
        ensure  => 'present',
        owner   => 'nobody',
        group   => 'nobody',
        mode    => '0544',
        content => template('adops/cron-payoutcache'),
    }

    file { '/usr/local/bin/check_payout_cache_daily':
        ensure  => 'present',
        owner   => 'nobody',
        group   => 'nobody',
        mode    => '0755',
        content => template('adops/check_payout_cache_daily.erb'),
    }

    file { '/usr/local/bin/check_cliafn_daily':
        ensure  => 'present',
        owner   => 'nobody',
        group   => 'nobody',
        mode    => '0755',
        content => template('adops/check_cliafn_daily.erb'),
    }

    file { '/usr/local/bin/check_rtb_mappings':
        ensure  => 'present',
        owner   => 'nobody',
        group   => 'nobody',
        mode    => '0755',
        content => template('adops/check_rtb_mappings.erb'),
    }


### DATABASE AND OTHER CREDENTIALS

  ## DFP COORDINATOR
    ## app_dfp_scheduler database.php
    $host_adops_app_dfp_scheduler_dfp_scheduler = 'vip-sqlrw-adops.ap.stg.lax.gnmedia.net'
    $user_adops_app_dfp_scheduler_dfp_scheduler = 'dfp_w'
    $pw_adops_app_dfp_scheduler_dfp_scheduler = decrypt("RTZ0DINCxKhSBFkxgXxUhQ==")

    ### adops creds
    $host_adops_app_dfp_scheduler_adops = 'vip-sqlrw-adops.ap.stg.lax.gnmedia.net'
    $user_adops_app_dfp_scheduler_adops = 'dfp_w'
    $pw_adops_app_dfp_scheduler_adops = decrypt("RTZ0DINCxKhSBFkxgXxUhQ==")

    file {'/app/shared/docroots/dfp_coordinator/config/app_dfp_scheduler.database.php':
        content => template('adops/app_dfp_scheduler.database.php.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
    ## end app_dfp_scheduler database.php

  ## DFP CREDENTIALS
    ## app_dfp_scheduler dfp_auth.ini
    ## dfp credentials for r/o access to the prod network
    $email_adops_app_dfp_scheduler_dfp_auth = 'addevelopers@evolvemediallc.com'
    $pw_adops_app_dfp_scheduler_dfp_auth = decrypt('IeN+zymCCaqMvi5b3xyKlw==')
    $appname_adops_app_dfp_scheduler_dfp_auth = 'GorillaNation AdOps3'
    $network_adops_app_dfp_scheduler_dfp_auth = '4403'

    ## OATH2 r/o credentials for either DFP network
    $client_id_dfp_scheduler_dfp_auth = decrypt('4p3t291Kx/FID8wZlJUx1VZ8TaZnN4/MSrPEam1p8Cgme3miL7fi3mTDeZua7oy23IphXI886u8vR76A4/jb+aCqdN5edpHMcXeqk0ssat4=')
    $client_secret_dfp_scheduler_dfp_auth = decrypt('NDyBi5wvxzgW0vuKgFEwoOGQJap9z2R9pi7+V+P56Y0=')
    $refresh_token_dfp_scheduler_dfp_auth = decrypt('dJh08EIJC0MAe7co6ZRT1784LfXxdhCj4fK0B+Te/0n9PHbAYOQwUL33fOgZ//Z2')

    ## dfp credentials for r/w to the test network
    ## app_dfp_scheduler dfp_auth.ini
#    $email_adops_app_dfp_scheduler_dfp_auth = 'addevelopers@gorillanation.com'
#    $pw_adops_app_dfp_scheduler_dfp_auth = decrypt('HXYSpe0BnlSmuWOniWA4Yg==')
#    $appname_adops_app_dfp_scheduler_dfp_auth = 'Ad Ops TEST'
#    $network_adops_app_dfp_scheduler_dfp_auth = '17425867'

    ## OAUTH2 r/w credentials for either DFP network
#    $client_id_dfp_scheduler_dfp_auth = decrypt('7saMCECTExTBDhCBk7O7Nl30l5dFEEC6sVyDuw50l8BBWh1dZQNoLvFB31xsfBFybJIz9Lfq9u0Hg6Fsuojv6zquzMG8eZoEaak+0Yco0BM=')
#    $client_secret_dfp_scheduler_dfp_auth = decrypt('4+cobkNwTUdu6kKf/U/2CxSm+8ifzvblLjoeR19XDpQ=')
#    $refresh_token_dfp_scheduler_dfp_auth = decrypt('/ZuwzrQMsLo1UU+d680hnRzyRt3gxja2i7K+Fo+rg7DN2OKbEDUZSgcCgmyn3rpj')

    file {'/app/shared/docroots/dfp_coordinator/config/app_dfp_scheduler.dfp_auth.ini':
        content => template('adops/app_dfp_scheduler.dfp_auth.ini.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

  ## END DFP CREDENTIALS


### CRONS

    Cron {
        environment => ["PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin", "RAILS_ROOT=/app/shared/docroots/adops.gorillanation.com/current/", "RAILS_ENV=staging","HOME=/app/shared/docroots/adops.gorillanation.com/current/","MAILTO=AdPlatformEmailtesting@gorillanation.com"],
    }

# Cron to manage partitions
    $host_partition_man = 'vip-sqlrw-adops.ap.stg.lax.gnmedia.net'
    $user_partition_man = 'partition_man'
    $pw_partition_man = decrypt('XPFWFIJBgKbhscpu6f3h+CguwiZJlZe7AtBkLhJ99pQ=')

    # the cronjob needs these packages
    package { ['perl-DBI','perl-DBD-MySQL']:
        ensure => installed,
    }

    file { '/usr/local/bin/manage-partition.pl':
        ensure  => present,
        owner   => 'root',
        group   => 'mysql',
        mode    => '0750',
        content => template('adops/manage-partition.pl'),
    }

    file { '/usr/local/bin/manage-partition.sh':
        ensure  => present,
        owner   => 'root',
        group   => 'mysql',
        mode    => '0750',
        content => template('adops/manage-partition.sh'),
    }

    cron { 'ManagePartitions':
        ensure      => present,
        user        => 'mysql',
        command     => '/usr/local/bin/manage-partition.sh',
        hour        => '1',
        minute      => '15',
        monthday    => '25',
    }
# End of Cron to manage mysql partitions

    # New rake wrapper for crons
    file {'/usr/local/bin/adops_rake.sh':
        ensure  => 'present',
        owner   => 'nobody',
        group   => 'nobody',
        mode    => '0544',
        content => template('adops/adops_rake.sh'),
    }

#    cron::monitor { 'important': warntime => 30, crittime => 60 }

    # run the previous three months of PayoutCache
    cron { 'PayoutCachePrev3Months':
        ensure      => present,
        user        => 'nobody',
        command     => "/usr/local/bin/adops_rake.sh 'payout_cache:cron_for_previous_three_months'",
        hour        => '20',
        minute      => '00',
        require     => File['/usr/local/bin/adops_rake.sh'],
    }

    ## NOTE:  This job must run *after* the data from DFP has been processed by process-report. We're moving the payoutcache job to run at
    ## 4:30 AM (6:30am in staging), with the belief that the DFP job will have been scheduled, returned, and processed by 4:15 or so (6:15 in staging).
    ##
    cron { 'PayoutCacheYesterday':
        ensure      => present,
        user        => 'nobody',
        command     => "/usr/local/bin/adops_rake.sh 'payout_cache:cron_for_yesterday'",
        hour        => '6',
        minute      => '30',
        require     => File['/usr/local/bin/adops_rake.sh'],
    }

    cron { 'run_emailer':
        ensure      => present,
        user        => 'nobody',
        command     => "cd /app/shared/docroots/adops.gorillanation.com/current/php/cronjobs && bash -c 'php run_emailer.php'",
        hour        => '*',
        minute      => '*',
    }

    cron { 'GetExchangeCurrencyRates':
        ensure      => present,
        user        => 'nobody',
        command     => "cd /app/shared/docroots/adops.gorillanation.com/current && bundle exec /app/shared/docroots/adops.gorillanation.com/current/script/runner 'Cronjob::GetExchangeCurrencyRates.run!'",
        monthday    => '1',
        hour        => '0',
        minute      => '15',
    }

    cron { 'AuthorityAutoconfirm':
        user        => 'nobody',
        command     => "cd /app/shared/docroots/adops.gorillanation.com/current && bundle exec /app/shared/docroots/adops.gorillanation.com/current/script/runner 'Cronjob::AuthorityAutoconfirm.run!'",
        hour        => '*',
        minute      => '0',
    }

    cron { 'ContractAutorenew':
        user        => 'nobody',
        command     => "cd /app/shared/docroots/adops.gorillanation.com/current && bundle exec /app/shared/docroots/adops.gorillanation.com/current/script/runner 'Contract.autorenew_all_applicable_contracts'",
        hour        => '1',
        minute      => '0',
    }

# For Master Payout Reports prior to 10/01/2013
    cron { 'LegacyMasterPayoutReport':
        user        => 'apache',
        command     => "cd /app/shared/docroots/adops.gorillanation.com/current && bundle exec /app/shared/docroots/adops.gorillanation.com/current/script/runner 'Cronjob::MasterPayoutReport.new.run!'",
        hour        => '*',
        minute      => [1,6,11,16,21,26,31,36,41,46,51,56],
    }

    cron { 'AdopsMasterPayoutReport':
        ensure      => present,
        user        => 'apache',
        command     => "cd /app/shared/docroots/adops.gorillanation.com/current && bundle exec /app/shared/docroots/adops.gorillanation.com/current/script/runner 'Cronjob::AdopsMasterPayoutReport.new.run!'",
        hour        => '*',
        minute      => '*/5',
    }

    # Pre-calculated master payout
    cron { 'SharedMasterPayout':
        ensure      => present,
        user        => 'nobody',
        command     => "/usr/local/bin/adops_rake.sh 'payout_cache:shared_master_payout'",
        hour        => '01',
        minute      => '00',
        require     => File['/usr/local/bin/adops_rake.sh'],
    }

    cron { 'subnet_reports':
        user        => 'apache',
        command     => "cd /app/shared/docroots/adops.gorillanation.com/current && bundle exec /app/shared/docroots/adops.gorillanation.com/current/script/runner 'Cronjob::SubnetReports.run!'",
        hour        => '*',
        minute      => '*/10',
    }

    cron { 'PopulatePayoutCache':
        ensure      => absent,
        user        => 'nobody',
        command     => '/usr/local/bin/cron-payoutcache',
        hour        => '4',
        minute      => '30',
    }

    cron { 'PayoutCacheHistorical':
        ensure      => absent,
        user        => 'nobody',
        command     => "cd /app/shared/docroots/adops.gorillanation.com/current && bundle exec /app/shared/docroots/adops.gorillanation.com/current/script/runner 'Cronjob::PopulatePayoutCacheHistorical.run!'",
        hour        => '*',
        minute      => '*/5',
    }

    #BE CAREFUL NEVER TO RUN THE SCHEDULER IN STG WITH R/W ACCESS TO PRODUCTION DFP
    cron { 'dfp_scheduler':
        ensure      => absent,
        user        => 'apache',
        command     => "flock -x -n /tmp/dfp_scheduler.lock make -C /app/shared/docroots/dfp_coordinator/htdocs run-scheduler 2>&1 >> /app/log/dfp/apache/dfp_scheduler.log",
        hour        => '*',
        minute      => '*',
    }

    cron { 'report_scheduler':
        ensure      => present,
        user        => 'apache',
        command     => "flock -x -n /tmp/report_scheduler.lock make -C /app/shared/docroots/dfp_coordinator/htdocs schedule-report >> /app/log/dfp/apache/report_scheduler.log",
        hour        => '5',
        minute      => '4',
    }

    cron { 'report_processor':
        ensure      => present,
        user        => 'apache',
        command     => "flock -x -n /tmp/report_processor.lock make -C /app/shared/docroots/dfp_coordinator/htdocs process-report >> /app/log/dfp/apache/report_scheduler.log",
        hour        => '*',
        minute      => '*/15',
    }

    # RTB Cron
    cron { 'RTB_Daily':
        ensure      => present,
        user        => 'apache',
        command     => 'make -C /app/shared/docroots/dfp_coordinator/htdocs performax-process-all >> /app/log/dfp/apache/performax-process-all.log 2>&1',
        hour        => '21',
        minute      => '30',
    }

    # ZERGNET
    cron { 'get_zergnet_traffic':
        ensure      => present,
        user        => 'nobody',
        command     => "source /app/software/python/pyenvrc ; cd /app/shared/zergnet/ ; ./get_zergnet_traffic.py",
        hour        => '4',
        minute      => '0',
    }

    cron { 'get_zergnet_paid':
        ensure      => present,
        user        => 'nobody',
        command     => "source /app/software/python/pyenvrc ; cd /app/shared/zergnet/ ; ./get_zergnet_paid.py",
        hour        => '4',
        minute      => '5',
    }

    ### FOR SOFTWARE PROMOTION
    file {'/usr/local/bin/ap_sw.sh':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template('adops/ap_sw.sh.erb'),
    }

    file {'/usr/local/bin/promote_software_stg_to_prd.sh':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template('adops/promote_software_stg_to_prd.sh.erb'),
    }

    file {'/app/software-prd':
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }
    ### END FOR SOFTWARE PROMOTION
  ### GEOIP CRONS ###
  cron { 'geoip_update':
    ensure  => present,
            user    => 'adops-deploy',
            minute  => '12',
            hour    => '23',
            weekday => '3',
            command => '/usr/bin/geoipupdate -f /app/shared/docroots/geoip.evolvemediallc.com/shared/config/GeoIP.conf -d /app/shared/docroots/geoip.evolvemediallc.com/shared/data',
  }


  ### END GEOIP CRONS ###


}
