# vim: set ts=2 sw=2 et :
# Install NewRelic Sysmond plugin
# https://docs.newrelic.com/docs/servers/new-relic-servers-linux
class newrelic::sysmond {
  include yum::newrelic::live
  include newrelic::params

  $newrelic_lic     = $newrelic::params::license
  $newrelic_log_dir = $newrelic::params::log_path

  file {"${newrelic::params::conf_path}/nrsysmond.cfg":
    content => template('newrelic/nrsysmond.cfg.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['newrelic-sysmond'],
  }

  package { 'newrelic-sysmond':
    ensure  => present,
    require => File['/etc/newrelic/nrsysmond.cfg']
  }

  service { 'newrelic-sysmond':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['newrelic-sysmond']
  }
}
