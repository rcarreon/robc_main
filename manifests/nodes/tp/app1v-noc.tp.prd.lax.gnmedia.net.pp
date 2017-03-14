node 'app1v-noc.tp.prd.lax.gnmedia.net' {
    ###TESTING ####
    include base
    $project="admin"

    include common::app
    include httpd
    include hi5

    class {"mysqld56": template=>"noc.tp.prd.lax-standalone"}
   

    package { ['subversion', 'ansible', 'python-pip']:
      ensure => "installed",
    }

    class { 'php::install':
        version => '5.3',
        extra_packages => ['php-ldap'],
    }

    httpd::virtual_host { 'noctools.gnmedia.net':
       expect => 'Status:',
    }  

    httpd::virtual_host { 'statuschange.gnmedia.net': }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_shared/noc-shared",
    }

    common::nfsmount { "/app/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_log/app1v-noc.tp.prd.lax.gnmedia.net",
    }

    file { '/app/shared/http':
        ensure => directory,
    }

    file { '/app/ugc':
        ensure => directory,
    }

    #NOCTools Directory
    file {'/app/shared/http/noctools':
       ensure  => directory,
       owner   => 'apache',
       mode    => '0775',
    } 

    #NocReports Cronjob Run pingdom_checks.php every min
    cron { pingdom_checks:
        user => deploy,
        ensure => present,
        minute => '*',
        command => "/app/shared/http/noctools/bin/pingdom_checks.php"
    }

    #NocReports Cronjob Run script which updates websites and servers relationship
    cron { reports_update:
        user => deploy,
        ensure => present,
        weekday => [1, 5],
        hour => [10],
        minute => 0,
        command => "/app/shared/http/noctools/bin/reports_update"
    }

    cron { "dogtimebulkpurge":
      user => "root",
      ensure => "present",
      minute => "30",
      hour => "1",
      command => 'dogtimebulkpurge --cloud-name dogtime-balto --dump from=`date --date="-3 weeks 1 day ago" +\%F`,to=`date --date="-3 weeks" +\%F` | dogtimebulkpurge --cloud-name dogtime-balto --purge > /dev/null'
    }

    #NocReports Cronjob script that updates the site list from RT
    cron { nrt_rt_update:
        user => deploy,
        ensure => present,
        minute => "55",
        hour => "1",
        weekday => "*",
        command => "/app/shared/http/noctools/bin/nrt-updatesites.php"
    }

  #make sure NOCTOOLS Crontabs are executables ** reports_update
  file {"/app/shared/http/noctools/bin/reports_update":
    ensure => file,
    owner => deploy,
    mode => 755
  }

  #make sure NOCTOOLS Crontabs are executables ** nrt-updatesites.php
  file {"/app/shared/http/noctools/bin/nrt-updatesites.php":
    ensure => file,
    owner => deploy,
    mode => 755
  }
                
  #make sure NOCTOOLS Crontabs are executables ** pingdom_checks_bg
  file {"/app/shared/http/noctools/bin/pingdom_checks_bg":
    ensure => file,
    owner => deploy,
    mode => 755
  }

  #make sure NOCTOOLS Crontabs are executables ** probesUpdate.php
  file {"/app/shared/http/noctools/bin/probesUpdate.php":
    ensure => file,
    owner => deploy,
    mode => 755
  }

    #NocReports File
    file {"/app/log/pingdom-checks.log":
       ensure => file,
       owner  => deploy,
       mode   => 775
    }
    
    #NocReports File
    file {"/app/log/nocreports_update.log":
      ensure => file,
      owner  => deploy,
      mode   => 775
    }

  #RT monthly report script
    file {"/var/lib/rt_script":
    ensure => directory,
    owner  => root,
    mode   => 775
  }

  file {"/var/lib/rt_script/monthly_vertical_gen.sh":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => 755,
    source => "puppet:///modules/common/monthly_vertical_gen.sh",
  }

  file {"/var/lib/rt_script/manual_monthly_vertical_gen.sh":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => 755,
    source => "puppet:///modules/common/manual_monthly_vertical_gen.sh",
  }

  #Cronjob to run rt monthly script each day 1st of every month
  cron { rt_monthly:
    user   => root,
    ensure => present,
    minute => [0],
    hour   => [0],
    monthday   => [1],
    command => "/bin/sh /var/lib/rt_script/monthly_vertical_gen.sh"
  }

  # SQL volume mounts
  common::nfsmount { "/sql/data":
    device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_app1v_noc_tp_prd_lax_data",
  }

  common::nfsmount { "/sql/binlog":
    device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_app1v_noc_tp_prd_lax_binlog",
  }

  common::nfsmount { "/sql/log":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_sql_log/app1v-noc.tp.prd.lax.gnmedia.net",
  }
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include newrelic::mysql
}
