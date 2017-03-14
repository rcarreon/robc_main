# directories needed for adops
class adops::newrelic::nfs {
  include yum::newrelic::live
  include adops::newrelic::params

  $log_level    = 'WARN'
  $log_interval = '60'
  $log_file     = '/var/log/newrelic-nfsiostat.log'
  $pid_file     = '/var/run/newrelic-nfsiostat.pid'
  $newrelic_lic = $adops::newrelic::params::license



  package { 'python-daemon':
    ensure => installed,
  }

  package { 'python-psutil':
    ensure => installed,
  }

  package { 'newrelic-nfsiostat':
    ensure  => installed,
    require => [
      Class['yum::newrelic::live'],
      Package['python-daemon'],
      Package['python-psutil'],
    ]
  }

  file { '/etc/newrelic-nfsiostat.conf':
    content => template("adops/newrelic-nfsiostat.conf.erb"),
    require => Package['newrelic-nfsiostat'],
  }

  service {'newrelic-nfsiostat':
    enable          => true,
    ensure          => running,
    hasstatus       => true,
    hasrestart      => true,
  }
}
