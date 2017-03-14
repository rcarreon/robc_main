# vim: set ts=2 sw=2 et :
# Install newrelic-nfsiostat plugin
# http://newrelic.com/plugins/delivery-agent-inc-non-prod/217
# https://github.com/LarkIT/newrelic-nfsiostat
class newrelic::nfsiostat {
  include yum::newrelic::live
  include newrelic::params

  $newrelic_lic     = $newrelic::params::license
  $newrelic_log_dir = $newrelic::params::log_path

  file {"${newrelic::params::conf_path}/nfsiostat.cfg":
    content => template('newrelic/nfsiostat.cfg.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }->file { '/etc/newrelic-nfsiostat.conf':
    ensure => link,
    target => "${newrelic::params::conf_path}/nfsiostat.cfg",
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }


  package { ['python-daemon', 'python-psutil']: ensure => installed }

  package { 'newrelic-nfsiostat':
    ensure  => installed,
    require => [
      Class['yum::newrelic::live'],
      File["${newrelic::params::conf_path}/nfsiostat.cfg"],
      Package['python-daemon'],
      Package['python-psutil'],
    ]
  }

  service { 'newrelic-nfsiostat':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['newrelic-nfsiostat']
  }
}
