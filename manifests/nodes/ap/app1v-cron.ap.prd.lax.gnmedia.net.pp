node 'app1v-cron.ap.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    $project='adops'
    include adops::packages
    include adops::appdirs
    include adopsV3::appdirs
    include dfp::appdirs
    include adops::dfp_rtb_creds
    include ap::cron::gp
    include ap::cron::gp::prd
    include adops::common
    include adops::rbenv
    include php::adops
    include monit::dfp_scheduler
    include adops::newrelic::apm
    include adops::newrelic::sysmond

    package {'git':
      ensure => installed
    }


### MOUNTS

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_shared/adops-shared",
    }

    common::nfsmount { "/app/ugc":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_prd_app_ugc/",
        options => "nfsvers=3,noatime,rw,rsize=32768,wsize=32768,hard,intr,tcp,noexec,nosuid",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_log/app1v-cron.ap.prd.lax.gnmedia.net",
    }

    common::nfsromount { "/app/software":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_shared/ap-software-prd",
    }


### PACKAGES

    package {['gcc','ruby-devel']:
            ensure => present,
    }

#    #freetds needed for GP V3
#    package {'freetds':
#            ensure => present,
#    }

    # mysql client needed for check_payout_cache_daily
    package {'mysql':
        ensure=> present,
    }

    # encrypted passwords
    $host_adops_cron_check_db='vip-sqlro-adops.ap.prd.lax.gnmedia.net'
    $payoutcheck_r=decrypt("OYbMjXK2lfT6HzmYcpmq5g==")

#    file {'/app/local/data':
#            ensure => directory,
#            owner  => 'root',
#            group  => 'root',
#    }
#
#    # candidate for removal/cleanup 07102013
#    file {'/app/local/data/dartftp':
#            ensure  => directory,
#            owner   => 'nobody',
#            group   => 'nobody',
#    }
#
#    file{'/app/local/data/adexchange':
#            ensure  => directory,
#            owner   => 'nobody',
#            group   => 'nobody',
#    }
#
#    file{'/app/local/data/adexchange/downloads':
#            ensure  => directory,
#            owner   => 'nobody',
#            group   => 'nobody',
#    }

#    file { '/app/local/logs/adopsV3_gp_scheduler':
#        ensure => directory,
#        owner  => 'apache',
#        group  => 'root',
#    }

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

    file { '/usr/local/bin/report_mistrafficked_line_items':
        ensure  => 'present',
        owner   => 'nobody',
        group   => 'nobody',
        mode    => '0755',
        content => template('adops/report_mistrafficked_line_items.erb'),
    }


### DATABASE AND OTHER CREDENTIALS

  ## DFP COORDINATOR
    ## app_dfp_scheduler database.php
    ### dfp_scheduler creds
    $host_adops_app_dfp_scheduler_dfp_scheduler = "vip-sqlrw-adops.ap.prd.lax.gnmedia.net"
    $user_adops_app_dfp_scheduler_dfp_scheduler = "dfp_w"
    $pw_adops_app_dfp_scheduler_dfp_scheduler = decrypt("QG7JgsTcSKgjBOQs75Fx8w==")

    ### adops creds
    $host_adops_app_dfp_scheduler_adops = "vip-sqlrw-adops.ap.prd.lax.gnmedia.net"
    $user_adops_app_dfp_scheduler_adops = "dfp_w"
    $pw_adops_app_dfp_scheduler_adops = decrypt("QG7JgsTcSKgjBOQs75Fx8w==")

    file {"/app/shared/docroots/dfp_coordinator/config/app_dfp_scheduler.database.php":
        content => template("adops/app_dfp_scheduler.database.php.erb"),
        owner   => "root",
        group   => "root",
        mode    => "0644",
    }
    ## end app_dfp_scheduler database.php

  ## DFP CREDENTIALS
    ## app_dfp_scheduler dfp_auth.ini
    $email_adops_app_dfp_scheduler_dfp_auth = 'adplatform%gorillanation.com@gtempaccount.com'
    $pw_adops_app_dfp_scheduler_dfp_auth = decrypt('Xp7aTTXhj4MrMq++UG7NFQ==')
    $appname_adops_app_dfp_scheduler_dfp_auth = 'GorillaNation AdOps3'
    $network_adops_app_dfp_scheduler_dfp_auth = '4403'

    ## OATH2 r/w credentials for prd DFP network
    $client_id_dfp_scheduler_dfp_auth = decrypt('7saMCECTExTBDhCBk7O7Nl30l5dFEEC6sVyDuw50l8BBWh1dZQNoLvFB31xsfBFybJIz9Lfq9u0Hg6Fsuojv6zquzMG8eZoEaak+0Yco0BM=')
    $client_secret_dfp_scheduler_dfp_auth = decrypt('4+cobkNwTUdu6kKf/U/2CxSm+8ifzvblLjoeR19XDpQ=')
    $refresh_token_dfp_scheduler_dfp_auth = decrypt('/ZuwzrQMsLo1UU+d680hnRzyRt3gxja2i7K+Fo+rg7DN2OKbEDUZSgcCgmyn3rpj')

    file {'/app/shared/docroots/dfp_coordinator/config/app_dfp_scheduler.dfp_auth.ini':
        content => template('adops/app_dfp_scheduler.dfp_auth.ini.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
  ## END DFP CREDENTIALS


### CRONS

    ## crons
    Cron {
        environment => ["PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin", "RAILS_ROOT=/app/shared/docroots/adops.gorillanation.com/current/", "RAILS_ENV=production","HOME=/app/shared/docroots/adops.gorillanation.com/current/","MAILTO=adplatform@gorillanation.com"],
    }

# Cron to manage partitions
    $host_partition_man = 'vip-sqlrw-adops.ap.prd.lax.gnmedia.net'
    $user_partition_man = 'partition_man'
    $pw_partition_man = decrypt('a+v2sJ1sN56YMWkBk9iquJsfttmvpVnhyYK3vlm4cQQ=')

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

    cron::monitor { 'important': warntime => 30, crittime => 60 }

    cron { 'adopsV3_gp_scheduler':
        ensure  => absent,
        command => "/usr/bin/php /app/shared/docroots/adopsV3/htdocs/app_gp_scheduler/Console/cake.php -app app_gp_scheduler gp_scheduler >> /app/log/adops3/apache/gp_scheduler.log",
        user    => 'apache',
        minute  => '*',
    }

    cron { 'gp_scheduler':
        ensure  => present,
        command => "make -C /app/shared/docroots/gp_coordinator/htdocs gp-scheduler >> /app/log/gp/apache/gp_scheduler.log",
        user    => 'apache',
        minute  => '*',
    }

    ## for production  set the RAILS_ROOT env variable prepend: 'RAILS_ENV=production'
    ## ie:$ RAILS_ENV=production script/runner '/script/to/run.rb'
    cron { 'run_emailer':
        user        => 'nobody',
        command     => "cd /app/shared/docroots/adops.gorillanation.com/current/php/cronjobs && bash -c 'php run_emailer.php'",
        hour        => '*',
        minute      => '*',
    }

    cron { 'GetExchangeCurrencyRates':
        user        => 'nobody',
        command     => "cd /app/shared/docroots/adops.gorillanation.com/current && bundle exec /app/shared/docroots/adops.gorillanation.com/current/script/runner 'Cronjob::GetExchangeCurrencyRates.run!'",
        monthday    => '1',
        hour        => '0',
        minute      => '15',
    }

    cron { 'AuthorityAutoconfirm':
        user        => 'nobody',
        command     => "cd /app/shared/docroots/adops.gorillanation.com/current && bundle exec /app/shared/docroots/adops.gorillanation.com/current/script/runner 'Cronjob::AuthorityAutoconfirm.run!'",
        hour        => "*",
        minute      => "0",
    }

    cron { 'PubContractExpiringNotice':
        user        => 'nobody',
        command     => "cd /app/shared/docroots/adops.gorillanation.com/current && bundle exec /app/shared/docroots/adops.gorillanation.com/current/script/runner 'Cronjob::PublishersContractExpiringNotice.run!'",
        weekday     => '0',
        hour        => '0',
        minute      => '0',
    }

    cron { 'AdexFinalReport':
        ensure      => absent,
        user        => 'nobody',
        command     => "cd /app/shared/docroots/adops.gorillanation.com/current && bundle exec /app/shared/docroots/adops.gorillanation.com/current/script/runner 'Cronjob::AdexFinalReport.run!'",
        weekday     => '0',
        monthday    => '4',
        hour        => '4',
        minute      => '0',
    }

    cron { 'SendCampaignTraffickerAssignmentsReport':
        ensure      => present,
        user        => 'nobody',
        command     => "cd /app/shared/docroots/adops.gorillanation.com/current && bundle exec /app/shared/docroots/adops.gorillanation.com/current/script/runner 'Campaign.send_campaign_trafficker_assignments_report'",
        hour        => '2',
        minute      => '0',
    }

    cron { 'ContractAutorenew':
        ensure      => present,
        user        => 'nobody',
        command     => "cd /app/shared/docroots/adops.gorillanation.com/current && bundle exec /app/shared/docroots/adops.gorillanation.com/current/script/runner 'Contract.autorenew_all_applicable_contracts'",
        hour        => '1',
        minute      => '0',
    }

    cron { 'WeeklyIOReport':
        ensure      => present,
        user        => 'nobody',
        command     => "cd /app/shared/docroots/adops.gorillanation.com/current && bundle exec /app/shared/docroots/adops.gorillanation.com/current/script/runner 'Report::weekly_io!'",
        weekday     => '1',
        hour        => '6',
        minute      => '15',
    }

    cron { 'email_planners_&traffickers':
        ensure      => absent,
        user        => 'nobody',
        command     => "(time /app/shared/docroots/reports/scripts/update_campaigns.py) >/app/log/adops/nobody/update_campaigns.log 2>&1",
        hour        => '8',
        minute      => '31',
    }

    cron { 'AdExchange_IMAP_download_into_DB':
        ensure      => absent,
        user        => 'nobody',
        command     => "(time /app/shared/docroots/reports/scripts/adExchangeProcessor.py) >/app/log/adops/nobody/adexchange.log 2>&1",
        monthday    => '2',
        hour        => '0',
        minute      => '0',
    }


# For Master Payout Reports prior to 10/01/2013
    cron { "LegacyMasterPayoutReport":
        ensure  => present,
        user    => 'apache',
        command => "cd /app/shared/docroots/adops.gorillanation.com/current && bundle exec /app/shared/docroots/adops.gorillanation.com/current/script/runner 'Cronjob::MasterPayoutReport.new.run!'",
        hour    => '*',
        minute  => [1,6,11,16,21,26,31,36,41,46,51,56],
    }

    cron { 'AdopsMasterPayoutReport':
        ensure  => present,
        user    => 'apache',
        command => "cd /app/shared/docroots/adops.gorillanation.com/current && bundle exec /app/shared/docroots/adops.gorillanation.com/current/script/runner 'Cronjob::AdopsMasterPayoutReport.new.run!'",
        hour    => '*',
        minute  => '*/5',
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
        ensure  => present,
        user    => 'apache',
        command => "cd /app/shared/docroots/adops.gorillanation.com/current && bundle exec /app/shared/docroots/adops.gorillanation.com/current/script/runner 'Cronjob::SubnetReports.run!'",
        hour    => '*',
        minute  => '*/10',
    }

    cron { 'sk_subnet_reports':
        ensure  => absent,
        user    => 'nobody',
        command => "/usr/local/bin/adops_rake.sh 'subnet_payout:sheknows_reporting'",
        hour    => '20',
        minute  => '0',
        weekday => '0',
    }

    cron { 'NewCampaignsReport':
        ensure  => present,
        user    => 'nobody',
        hour    => '0',
        minute  => '15',
        command => "cd /app/shared/docroots/adops.gorillanation.com/current && bundle exec /app/shared/docroots/adops.gorillanation.com/current/script/runner 'Cronjob::NewCampaignsReport.run!'",
    }

    # New rake task wrapper script for invoking cronjobs via rake tasks.
    file {'/usr/local/bin/adops_rake.sh':
        ensure  => present,
        owner   => 'nobody',
        group   => 'nobody',
        mode    => '0544',
        content => template('adops/adops_rake.sh'),
    }

    cron { 'dfp_scheduler':
        ensure      => present,
        user        => 'apache',
        command     => "flock -x -n /tmp/dfp_scheduler.lock make -C /app/shared/docroots/dfp_coordinator/htdocs run-scheduler 2>&1 >> /app/log/dfp/apache/dfp_scheduler.log",
        hour        => '*',
        minute      => '*',
    }

    cron { 'report_scheduler':
        user        => 'apache',
        command     => "flock -x -n /tmp/report_scheduler.lock make -C /app/shared/docroots/dfp_coordinator/htdocs schedule-report >> /app/log/dfp/apache/report_scheduler.log",
        hour        => '3',
        minute      => '4',
    }

    cron { 'report_processor':
        ensure      => present,
        user        => 'apache',
        command     => "flock -x -n /tmp/report_processor.lock make -C /app/shared/docroots/dfp_coordinator/htdocs process-report >> /app/log/dfp/apache/report_scheduler.log",
        hour        => '*',
        minute      => '*/15',
    }

    cron { 'company_payout_reports':
        ensure      => absent,
        user        => 'apache',
        command     => "cd /app/shared/docroots/adops.gorillanation.com/current && bundle exec script/runner 'Cronjob::CompanyPayoutReports.run!'",
        hour        => '*',
        minute      => '*',
    }

    cron { 'check_payout_cache_daily':
        ensure      => present,
        user        => 'nobody',
        command     => '/usr/local/bin/check_payout_cache_daily',
        hour        => '9',
        minute      => '30',
        require     => File['/usr/local/bin/check_payout_cache_daily'],
    }

    cron { 'check_rtb_mappings':
        ensure      => present,
        user        => 'nobody',
        command     => '/usr/local/bin/check_rtb_mappings',
        hour        => '9',
        minute      => '15',
        require     => File['/usr/local/bin/check_rtb_mappings'],
    }

    cron { 'report_mistrafficked_line_items':
        ensure      => present,
        user        => 'nobody',
        command     => '/usr/local/bin/report_mistrafficked_line_items',
        hour        => '7',
        minute      => '05',
        require     => File['/usr/local/bin/report_mistrafficked_line_items'],
    }

    # DFP scheduler check script
    file { '/usr/local/bin/check_dfp_scheduler_log.sh':
        ensure  => present,
        owner   => 'root',
        group   => 'apache',
        mode    => '0750',
        content => template('adops/check_dfp_scheduler_log.sh'),
    }

    cron { 'check_dfp_scheduler_log':
        ensure      => present,
        user        => 'apache',
        command     => "/usr/local/bin/check_dfp_scheduler_log.sh > /dev/null 2>&1",
        hour        => '*',
        minute      => '*/15',
    }
    # End DFP scheduler check script

    # DFP validated.csv check script
    file { '/usr/local/bin/check_dfp_csv.sh':
        ensure  => present,
        owner   => 'root',
        group   => 'apache',
        mode    => '0750',
        content => template('adops/check_dfp_csv.sh'),
    }

    cron { 'check_dfp_csv':
        ensure      => present,
        user        => 'apache',
        command     => "/usr/local/bin/check_dfp_csv.sh > /dev/null 2>&1",
        hour        => '7',
        minute      => '15',
    }
    # End DFP validated.csv check script

    cron { 'check_cliafn_daily':
        ensure      => 'present',
        user        => 'nobody',
        command     => '/usr/local/bin/check_cliafn_daily',
        hour        => '9',
        minute      => '31',
        require     => File['/usr/local/bin/check_cliafn_daily'],
    }

    # RTB Cron (currently part of the dfp_coordinator)
    cron { 'RTB_Daily':
        ensure      => present,
        user        => 'apache',
        command     => 'make -C /app/shared/docroots/dfp_coordinator/htdocs performax-process-all >> /app/log/dfp/apache/performax-process-all.log 2>&1',
        hour        => '21',
        minute      => '0',
    }
    # END RTP CRON

    cron { 'Sync_New_Ads_Daily':
        ensure      => present,
        user        => 'apache',
        command     => 'make -C /app/shared/docroots/dfp_coordinator/htdocs sync-new-ad-units  >> /app/log/dfp/apache/sync-new-ad-units.log 2>&1',
        hour        => '*',
        minute      => '*/5',
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
}
