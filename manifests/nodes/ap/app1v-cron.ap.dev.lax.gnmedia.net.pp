node 'app1v-cron.ap.dev.lax.gnmedia.net' {
    include base
    $project="adops"
    include adops::packages
    include adops::rbenv
    include adops::appdirs
    include adopsV3::appdirs
    include dfp::appdirs
    include adops::dfp_rtb_creds
    include ap::cron::gp
    include ap::cron::gp::dev
    include adops::common
    include php::adops
    include sendmail::tarpit

    include adops::newrelic::apm

    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat

### MOUNTS

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/adops-shared",
    }

    common::nfsmount { "/app/ugc":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_dev_app_ugc/",
        options => "nfsvers=3,noatime,rw,rsize=32768,wsize=32768,hard,intr,tcp,noexec,nosuid",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_log/app1v-cron.ap.dev.lax.gnmedia.net",
    }

    common::nfsromount { "/app/software":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/ap-software-dev",
    }

### PACKAGES

#    #freetds needed for GP V3
#    package {"freetds":
#            ensure => present,
#    }

    package {"tmux":
            ensure => present,
    }

    package {"git":
      ensure => present,
    }

    # pyenv's dependencies
    package { ["gcc", "zlib-devel", "bzip2-devel", "readline-devel", "sqlite-devel", "openssl-devel"]:
      ensure => present,
    }

    # passwords
    $host_adops_cron_check_db='sql1v-56-adops.ap.dev.lax.gnmedia.net'
    $payoutcheck_r=decrypt("OYbMjXK2lfT6HzmYcpmq5g==")

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
    ### dfp_scheduler creds
    $host_adops_app_dfp_scheduler_dfp_scheduler = "sql1v-56-adops.ap.dev.lax.gnmedia.net"
    $user_adops_app_dfp_scheduler_dfp_scheduler = "dfp_w"
    $pw_adops_app_dfp_scheduler_dfp_scheduler = decrypt("p79nZBfb21uP6uQWC4VM3A==")

    ### adops creds
    $host_adops_app_dfp_scheduler_adops = "sql1v-56-adops.ap.dev.lax.gnmedia.net"
    $user_adops_app_dfp_scheduler_adops = "dfp_w"
    $pw_adops_app_dfp_scheduler_adops = decrypt("p79nZBfb21uP6uQWC4VM3A==")

    file {"/app/shared/docroots/dfp_coordinator/config/app_dfp_scheduler.database.php":
        content => template("adops/app_dfp_scheduler.database.php.erb"),
        owner   => "root",
        group   => "root",
        mode    => "0644",
    }
    ## end app_dfp_scheduler database.php

  ## DFP CREDENTIALS
    ## dfp credentails for r/o access to the prod network
    ## app_dfp_scheduler dfp_auth.ini
    #$email_adops_app_dfp_scheduler_dfp_auth = 'addevelopers@evolvemediallc.com'
    #$pw_adops_app_dfp_scheduler_dfp_auth = decrypt('IeN+zymCCaqMvi5b3xyKlw==')
    #$appname_adops_app_dfp_scheduler_dfp_auth = "GorillaNation AdOps3"
    #$network_adops_app_dfp_scheduler_dfp_auth = "4403"

    ## OATH2 r/o credentials for either DFP network
    #
    $client_id_dfp_scheduler_dfp_auth = decrypt('9lNvbqqgXX54j7wD1+IDT1kUVJAR3ZF46MLsLXJHnGDcjxYKvV7bgi3ZAnqMF9rZmQY4Cxx19OtomLJzriyjnEpw50mbdVQHpjrMdoBbD0M=')
    $client_secret_dfp_scheduler_dfp_auth = decrypt('ljX7xr2zjThfDugY4B7yGTYztQb4Xuz/NHbtsTixnBg=')
    # nb5RdkLDGCF3OkovDfL7GeGKT0Hfz9qx8B19TaABvb7VbiVgA2H+ZewmRcWkbOt3u2uvq4CW10rf0wEvhI1GLWHEJtQlcUKvXBL0/KU//HA=
    $refresh_token_dfp_scheduler_dfp_auth = decrypt('nb5RdkLDGCF3OkovDfL7GeGKT0Hfz9qx8B19TaABvb7VbiVgA2H+ZewmRcWkbOt3u2uvq4CW10rf0wEvhI1GLWHEJtQlcUKvXBL0/KU//HA=')

    ## app_dfp_scheduler dfp_auth.ini
    $email_adops_app_dfp_scheduler_dfp_auth = 'adopsapi@evolvemediallc.com'
    $pw_adops_app_dfp_scheduler_dfp_auth = '#no_password_required'
    $appname_adops_app_dfp_scheduler_dfp_auth = "Adops Application Api"
    $network_adops_app_dfp_scheduler_dfp_auth = '431096448'


    file {'/app/shared/docroots/dfp_coordinator/config/app_dfp_scheduler.dfp_auth.ini':
        content => template('adops/app_dfp_scheduler.dfp_auth.ini.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

  ## END DFP CREDENTIALS


# Testing deleting these on 8/21/14
#    # candidate for removal/cleanup 07102013
#    file {"/app/local/data/dartftp":
#            ensure  => directory,
#            owner   => "nobody",
#            group   => "nobody",
#    }
#
#    file {"/app/local/data/adexchange":
#            ensure  => directory,
#            owner   => "nobody",
#            group   => "nobody",
#    }
#
#    file {"/app/local/data/adexchange/downloads":
#            ensure  => directory,
#            owner   => "nobody",
#            group   => "nobody",
#    }


### CRONS

    Cron {
        environment => ["PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin", "RAILS_ROOT=/app/shared/docroots/adops.gorillanation.com/htdocs/", "RAILS_ENV=development","HOME=/app/shared/docroots/adops.gorillanation.com/htdocs/","MAILTO=AdPlatformEmailtesting@gorillanation.com"],
    }

# Cron to manage mysql partitions
    $host_partition_man = 'sql1v-56-adops.ap.dev.lax.gnmedia.net'
    $user_partition_man = 'partition_man'
    $pw_partition_man = decrypt('5wMrDo3zKLXNnXjcEYyLTxoRMutDLTE8/Djjy+3GjCc=')

    # the cronjob needs these packages
    package { ["perl-DBI","perl-DBD-MySQL"]:
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
    file {"/usr/local/bin/adops_rake.sh":
        ensure  => present,
        owner   => 'nobody',
        group   => 'nobody',
        mode    => '0544',
        content => template('adops/adops_rake.sh'),
    }

#  cron::monitor { "important": warntime => 30, crittime => 60 }

    cron { "run_emailer":
        user        => "nobody",
        command     => "cd /app/shared/docroots/adops.gorillanation.com/htdocs/php/cronjobs && bash -c 'php run_emailer.php'",
        hour        => "*",
        minute      => "*",
    }

    cron { "GetExchangeCurrencyRates":
        user        => "nobody",
        command     => "cd /app/shared/docroots/adops.gorillanation.com/htdocs && bundle exec /app/shared/docroots/adops.gorillanation.com/htdocs/script/runner 'Cronjob::GetExchangeCurrencyRates.run!'",
        monthday    => "1",
        hour        => "0",
        minute      => "15",
    }

    cron { "AuthorityAutoconfirm":
        user        => "nobody",
        command     => "cd /app/shared/docroots/adops.gorillanation.com/htdocs && bundle exec /app/shared/docroots/adops.gorillanation.com/htdocs/script/runner 'Cronjob::AuthorityAutoconfirm.run!'",
        hour        => "*",
        minute      => "0",
    }

    cron { "ContractAutorenew":
        user        => "nobody",
        command     => "cd /app/shared/docroots/adops.gorillanation.com/htdocs && bundle exec /app/shared/docroots/adops.gorillanation.com/htdocs/script/runner 'Contract.autorenew_all_applicable_contracts'",
        hour        => "1",
        minute      => "0",
    }

# For Master Payout Reports prior to 10/01/2013
    cron { 'LegacyMasterPayoutReport':
        ensure  => present,
        user    => 'apache',
        command => "cd /app/shared/docroots/adops.gorillanation.com/htdocs && bundle exec /app/shared/docroots/adops.gorillanation.com/htdocs/script/runner 'Cronjob::MasterPayoutReport.new.run!'",
        hour    => '*',
        minute  => [1,6,11,16,21,26,31,36,41,46,51,56],
    }

    cron { 'AdopsMasterPayoutReport':
        ensure  => present,
        user    => 'apache',
        command => "cd /app/shared/docroots/adops.gorillanation.com/htdocs && bundle exec /app/shared/docroots/adops.gorillanation.com/htdocs/script/runner 'Cronjob::AdopsMasterPayoutReport.new.run!'",
        hour    => '*',
        minute  => '*/5',
    }

    cron { "subnet_reports":
        user        => "apache",
        command     => "cd /app/shared/docroots/adops.gorillanation.com/htdocs && bundle exec /app/shared/docroots/adops.gorillanation.com/htdocs/script/runner 'Cronjob::SubnetReports.run!'",
        hour        => "*",
        minute      => "*/10",
    }

    # New populate payout cache script
    file {'/usr/local/bin/cron-payoutcache':
        ensure  => 'absent',
        owner   => 'nobody',
        group   => 'nobody',
        mode    => '0544',
        content => template('adops/cron-payoutcache'),
    }

    cron { 'PopulatePayoutCache':
        ensure      => absent,
        user        => 'nobody',
        command     => '/usr/local/bin/cron-payoutcache',
        hour        => '4',
        minute      => '30',
        require     => File['/usr/local/bin/cron-payoutcache'],
    }

    cron { "PayoutCacheHistorical":
        ensure      => absent,
        user        => 'nobody',
        command     => "cd /app/shared/docroots/adops.gorillanation.com/htdocs && bundle exec /app/shared/docroots/adops.gorillanation.com/htdocs/script/runner 'Cronjob::PopulatePayoutCacheHistorical.run!'",
        hour        => "*",
        minute      => "*/5",
    }

    # run the previous three months of PayoutCache
    cron { 'PayoutCachePrev3Months':
        ensure      => present,
        user        => 'nobody',
        command     => "/usr/local/bin/adops_rake.sh 'payout_cache:cron_for_previous_three_months'",
        hour        => '20',
        minute      => '0',
        require     => File['/usr/local/bin/adops_rake.sh'],
    }

    # run the previous three months of PayoutCache
    cron { 'SharedMasterPayout':
        ensure      => present,
        user        => 'nobody',
        command     => "/usr/local/bin/adops_rake.sh 'payout_cache:shared_master_payout'",
        hour        => '01',
        minute      => '0',
        require     => File['/usr/local/bin/adops_rake.sh'],
    }

    ## NOTE:  This job must run *after* the data from DFP has been processed by process-report. We're moving the payoutcache job to run at
    ## 4:30 AM, with the belief that the DFP job will have been scheduled, returned, and processed by 4:15 or so.
    ##
    cron { 'PayoutCacheYesterday':
        ensure      => present,
        user        => 'nobody',
        command     => "/usr/local/bin/adops_rake.sh 'payout_cache:cron_for_yesterday'",
        hour        => '4',
        minute      => '30',
        require     => File['/usr/local/bin/adops_rake.sh'],
    }

    # RTB Cron
    cron { 'RTB_Daily':
        ensure      => present,
        user        => 'apache',
        command     => 'make -C /app/shared/docroots/dfp_coordinator/htdocs performax-process-all >> /app/log/dfp/apache/performax-process-all.log 2>&1',
        hour        => '22',
        minute      => '0',
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

### SOFTWARE PROMOTION
    file {'/usr/local/bin/ap_sw.sh':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template('adops/ap_sw.sh.erb'),
    }

    file {'/usr/local/bin/promote_software_dev_to_stg.sh':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template('adops/promote_software_dev_to_stg.sh.erb'),
    }

    file {'/app/software-stg':
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }
### END FOR SOFTWARE PROMOTION

}
