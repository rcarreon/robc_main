class adops::newrelic::sysmond($app_name = 'adops') {
  include yum::newrelic::live
  include adops::newrelic::params

  $newrelic_lic       = $adops::newrelic::params::license
  $newrelic_log_dir   = '/var/log/newrelic'

  if $app_name == 'adops' {
    $newrelic_app_name  = $adops::newrelic::params::adops_app_name
  } else {
    $newrelic_app_name  = $adops::newrelic::params::pubops_app_name
  }

  file { $newrelic_log_dir:
    ensure => directory,
    mode   => '0755',
    owner  => 'newrelic',
    group  => 'newrelic',
  }

  file {"/etc/newrelic/nrsysmond.cfg":
    content => template("adops/newrelic-nrsysmond.cfg.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  package { 'newrelic-sysmond':
    ensure  => present,
    require => File['/etc/newrelic/nrsysmond.cfg']
  }

  service { 'newrelic-sysmond':
    enable     => true,
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['newrelic-sysmond']
  }
}
