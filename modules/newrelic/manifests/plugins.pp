class newrelic::plugins {
  include newrelic::params

  file {$newrelic::params::plugin_path:
    ensure => directory,
    mode   => '0755',
    owner  => $newrelic::params::system_user,
    group  => $newrelic::params::system_user,
  }

}
