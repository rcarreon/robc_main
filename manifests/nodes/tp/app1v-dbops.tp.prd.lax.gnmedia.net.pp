node 'app1v-dbops.tp.prd.lax.gnmedia.net' {
    include base
    $project='admin'
    include db_checksum
    include common::app
    class { 'php::install': version => '5.3' }
    cron::monitor { 'important': warntime => 30, crittime => 60 }
    include sendmail::monitor
    include rubygems
    include httpd
    include git::client
    sudo::install_template { 'dba-root': }
    httpd::virtual_host{'dbops.gnmedia.net': }
    include mysqld56::client

    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat

    common::nfsmount { '/app/shared':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_shared/dbops-shared',
    }

    common::nfsmount { '/app/log':
        device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_log/app1v-dbops.tp.prd.lax.gnmedia.net',
    }

    package { [ 'MySQL-python','percona-toolkit','perl-IO-Socket-SSL','perl-Net-LibIDN','perl-Net-SSLeay','mysql-connector-python','perl-Time-Piece','php-ldap','perl-suidperl','rrdtool' ]:
        ensure => installed,
    }
    package { [ 'python-simplejson','rubygem-sinatra','rubygem-json' ]:
        ensure => present,
    }

    file { '/app/shared/docroots/dbops.gnmedia.net':
        ensure => directory,
        owner  => 'deploy',
        group  => 'deploy',
        mode   => '0755',
    }

    file { [ '/app/shared/ci',
             '/app/shared/ci/events',
             '/app/shared/ci/cronjobs',
             '/app/shared/og',
             '/app/shared/og/events',
             '/app/shared/og/cronjobs',
             '/app/shared/ao',
             '/app/shared/ao/events',
             '/app/shared/ao/cronjobs',             
             '/app/shared/sbv',
             '/app/shared/sbv/events',
             '/app/shared/sbv/cronjobs' ]:
        ensure => directory,
        owner  => 'mysql',
        group  => 'mysql',
        mode   => '0755',
    }

    # Manage daily checksums for CI OLTP
    cron { 'db-checksum-stg-ci':
        ensure  => 'present',
        user    => 'root',
        minute  => 0,
        hour    => 16,
        command => '/usr/bin/python /usr/local/bin/dbchecksum -h sql1v-56-ci.ci.stg.lax.gnmedia.net -d tewn',
    }

    file { '/usr/local/bin/og_db_benchmark_report.pl':
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/common/og_db_benchmark_report.pl',
    }

    file { '/usr/local/bin/db-manage-partition.pl':
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/common/db-manage-partition.pl',
    }
    
    file { '/app/shared/ci/cronjobs/etl_website_metrics.php':
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/common/etl_website_metrics.php',
    }

    file { '/app/shared/ci/cronjobs/etl_analytics_metrics.php':
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/common/etl_analytics_metrics.php',
    }

    file { '/app/shared/ci/cronjobs/etl_oltp_to_audit.py':
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/common/etl_oltp_to_audit.py',
    }

    file { '/usr/local/bin/dbcode_monitor.php' :
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/common/dbcode_monitor.php',
    }

    file { '/usr/local/bin/dbcode_monitor_job.php' :
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/common/dbcode_monitor_job.php',
    }

    # Manage monthly partitions for OG     
    file { '/app/shared/og/cronjobs/og-db-manage-partitions.sh':       
        ensure  => present,        
        owner   => 'root',     
        group   => 'root',     
        mode    => '0755',     
        source  => 'puppet:///modules/common/og-db-manage-partitions.sh',      
    }      
       
    cron { 'og-db-manage-partitions':      
        ensure  => 'present',      
        user    => 'root',     
        hour    => '0',        
        minute  => '0',        
        monthday=> '1',        
        command => '/app/shared/og/cronjobs/og-db-manage-partitions.sh',       
    }      

    # Manage monthly report for OG     
    file { '/app/shared/og/cronjobs/og_db_benchmark.sh':       
        ensure  => present,        
        owner   => 'root',     
        group   => 'root',     
        mode    => '0755',     
        source  => 'puppet:///modules/common/og_db_benchmark.sh',      
    }      
       
    cron { 'og-db-benchmark':      
        ensure  => 'present',      
        user    => 'root',     
        hour    => '0',        
        minute  => '0',        
        monthday=> '1',        
        command => '/app/shared/og/cronjobs/og_db_benchmark.sh',       
    }      

    file { '/app/shared/ci/cronjobs/etl_moderator_stats.php':
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/common/etl_moderator_stats.php',
    }

    file { '/app/shared/ci/cronjobs/etl_cpc_landing_page.php':
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/common/etl_cpc_landing_page.php',
    }

    file { '/app/shared/ci/cronjobs/etl_css.php':
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/common/etl_css.php',
    }

    file { '/app/shared/og/cronjobs/etl_origin_analytics.php':
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/common/etl_origin_analytics.php',
    }

    file { '/app/shared/og/cronjobs/etl_evolve_analytics_adunit.php':
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/common/etl_evolve_analytics_adunit.php',
    }

    cron { 'etl-cpc-landing-page-stg':
        ensure  => 'present',
        user    => 'root',
        hour    => 2,
        minute  => 0,
        monthday=> '*',
        month   => '*',
        weekday => '*',
        command => '/app/shared/ci/cronjobs/etl_cpc_landing_page.php -e stg',
    }

    cron { 'etl-website-metrics-stg':
        ensure  => 'present',
        user    => 'root',
        hour    => '*',
        minute  => '0',
        monthday=> '*',
        month   => '*',
        weekday => '*',
        command => '/app/shared/ci/cronjobs/etl_website_metrics.php -e stg',
    }

    # Manage weekly partitions for CI
    file { '/app/shared/ci/cronjobs/ci-archive-cron.sh':
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/common/ci-archive-cron.sh',
    }

    cron { 'to-ci-archive':
        ensure  => 'present',
        user    => 'root',
        hour    => 0,
        minute  => 0,
        monthday=> '*',
        month   => '*',
        weekday => '1',
        command => '/app/shared/ci/cronjobs/ci-archive-cron.sh',
    }

    # Manage hourly partitions for CI
    file { '/app/shared/ci/cronjobs/ci-archive-hourly-cronjobs.sh' :
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/common/ci-archive-hourly-cronjobs.sh',
    }

    cron { 'to-ci-archive-hourly':
        ensure  => 'present',
        user    => 'root',
        hour    => '*',
        minute  => 0,
        monthday=> '*',
        month   => '*',
        weekday => '*',
        command => '/app/shared/ci/cronjobs/ci-archive-hourly-cronjobs.sh',
    }

    # ETL between CI-OLTP & CI-DW  Stage
    cron { 'ci_sync_websites_stg':
        ensure  => present,
        user    => 'mysql',
        hour    => [3,9,15,21],
        minute  => '0',
        command => '/app/shared/ci/cronjobs/sync_websites.py -e stg',
    }


    file { '/usr/local/bin/ci_add_widget_ctp_partition.py' :
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/common/ci_add_widget_ctp_partition.py',
    }

    file { '/app/shared/ci/cronjobs/sync_websites.py' :
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/common/sync_websites.py',
    }

    # CI Monthly prunning pages
    file { '/app/shared/ci/cronjobs/ci-prunning-url-pages.pl':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/common/ci-prunning-url-pages.pl',
    }

    cron { 'ci-prunning-url-pages':
        ensure  => 'present',
        user    => 'root',
        hour    => '10',
        minute  => '0',
        monthday=> '1',
        command => '/usr/bin/perl /app/shared/ci/cronjobs/ci-prunning-url-pages.pl',
    }

    cron { 'etl-moderator-stats-stg':
        ensure  => present,
        user    => 'root',
        minute  => '0',
        hour    => '*/3',
        month   => '*',
        weekday => '*',
        command => '/app/shared/ci/cronjobs/etl_moderator_stats.php -e stg',
    }

    cron { 'db-checksum':
        ensure  => 'present',
        user    => 'root',
        minute  => 0,
        hour    => 17,
        command => '/usr/bin/python /usr/local/bin/dbchecksum -h sql1v-56-ci.ci.prd.lax.gnmedia.net -d tewn',
    }

    cron { 'etl-cpc-landing-page-prd':
        ensure  => 'present',
        user    => 'root',
        hour    => 1,
        minute  => 0,
        monthday=> '*',
        month   => '*',
        weekday => '*',
        command => '/app/shared/ci/cronjobs/etl_cpc_landing_page.php -e prd > /dev/null 2>&1',
    }

    # Cronjob schedule for etl website metrics on data warehouse
    cron { 'etl-website-metrics-prd':
        ensure  => 'present',
        user    => 'root',
        hour    => '*',
        minute  => '*/10',
        monthday=> '*',
        month   => '*',
        weekday => '*',
        command => '/app/shared/ci/cronjobs/etl_website_metrics.php -e prd > /dev/null 2>&1',
    }

    # ETL between CI-OLTP & CI-DW  Production
    cron { 'ci_sync_websites_prd':
        ensure  => present,
        user    => 'mysql',
        hour    => '*/3',
        minute  => '0',
        command => '/app/shared/ci/cronjobs/sync_websites.py -e prd > /dev/null 2>&1',
    }

    cron { 'etl-moderator-stats-prd':
        ensure  => present,
        user    => 'root',
        minute  => '*/30',
        hour    => '*',
        month   => '*',
        weekday => '*',
        command => '/app/shared/ci/cronjobs/etl_moderator_stats.php -e prd > /dev/null 2>&1',
    }

    cron { 'etl_oltp_to_audit-stg':
        ensure  => present,
        user    => 'root',
        minute  => '0',
        hour    => '1',
        month   => '*',
        weekday => '*',
        command => '/app/shared/ci/cronjobs/etl_oltp_to_audit.py -e stg > /dev/null 2>&1',
    }

    cron { 'etl_oltp_to_audit-prd':
        ensure  => present,
        user    => 'root',
        minute  => '0',
        hour    => '1',
        month   => '*',
        weekday => '*',
        command => '/app/shared/ci/cronjobs/etl_oltp_to_audit.py -e prd > /dev/null 2>&1',
    }

    cron { 'ci_widgets_ctp_clean_partition_prd':
        ensure  => present,
        user    => 'root',
        minute  => '0',
        hour    => '*',
        month   => '*',
        weekday => '*',
        command => '/usr/bin/php /home/ddurand/ci_clean_partition.php > /dev/null 2>&1',
    }

    cron { 'dbcode-monitor':
        ensure  => present,
        user    => 'root',
        minute  => '*/5',
        hour    => '*',
        month   => '*',
        weekday => '*',
        command => '/usr/local/bin/dbcode_monitor_job.php > /dev/null 2>&1',
    }

    #SBV STATS Sync partners between PRD and STG
    file { '/app/shared/sbv/cronjobs/sbv_partner_sync.py':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/common/sbv_partner_sync.py',
    }

    cron { 'sbv_partner_sync':
        ensure  => 'present',
        user    => 'root',
        hour    => '23',
        minute  => '0',
        command => '/usr/bin/python /app/shared/sbv/cronjobs/sbv_partner_sync.py -s sql1v-56-stats-cms.sbv.prd.lax.gnmedia.net -d sql1v-56-stats-cms.sbv.stg.lax.gnmedia.net > /dev/null 2>&1',
    }

    #AO WP Awards
    file { '/app/shared/ao/cronjobs/wp_sp_update_awards_votes.py':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/common/wp_sp_update_awards_votes.py',
    }    

    cron { 'wp_sp_update_awards_votes-dev':
        ensure  => 'present',
        user    => 'root',
        hour    => '*/4',
        minute  => '0',
        command => '/usr/bin/python /app/shared/ao/cronjobs/wp_sp_update_awards_votes.py -e dev > /dev/null 2>&1',
    }

    cron { 'wp_sp_update_awards_votes-stg':
        ensure  => 'present',
        user    => 'root',
        hour    => '*/4',
        minute  => '0',
        command => '/usr/bin/python /app/shared/ao/cronjobs/wp_sp_update_awards_votes.py -e stg > /dev/null 2>&1',
    }

    cron { 'wp_sp_update_awards_votes-prd':
        ensure  => 'present',
        user    => 'root',
        hour    => '*/2',
        minute  => '0',
        command => '/usr/bin/python /app/shared/ao/cronjobs/wp_sp_update_awards_votes.py -e prd > /dev/null 2>&1',
    }

    #SDC SP Error Check
    file { '/app/shared/ao/cronjobs/sdc_sp_logerror_check.py':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/common/sdc_sp_logerror_check.py',
    }    

    cron { 'sdc_sp_logerror_check':
        ensure  => 'present',
        user    => 'root',
        minute  => '0',
        hour    => '*',
        month   => '*',
        weekday => '*',
        command => '/usr/bin/python /app/shared/ao/cronjobs/sdc_sp_logerror_check.py > /dev/null 2>&1',
    }

    # ORIGIN Evolve Analytics ETL
    cron { 'etl_origin_analytics_stg':
        ensure  => present,
        user    => 'mysql',
        minute  => '10',
        command => '/app/shared/og/cronjobs/etl_origin_analytics.php -e stg',
    }

    cron { 'etl_origin_analytics_prd':
        ensure  => present,
        user    => 'mysql',
        minute  => '10',
        command => '/app/shared/og/cronjobs/etl_origin_analytics.php -e prd',
    }

    cron { 'etl_adunit_analytics_stg':
        ensure  => present,
        user    => 'mysql',
        minute  => '15',
        command => '/app/shared/og/cronjobs/etl_evolve_analytics_adunit.php -e stg',
    }

    cron { 'etl_adunit_analytics_prd':
        ensure  => present,
        user    => 'mysql',
        minute  => '15',
        command => '/app/shared/og/cronjobs/etl_evolve_analytics_adunit.php -e prd',
    }

}