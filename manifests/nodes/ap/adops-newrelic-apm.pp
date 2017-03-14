# directories needed for adops
class adops::newrelic::apm($app_name = 'adops') {
  include adops::newrelic::params

  $newrelic_lic      = $adops::newrelic::params::license
  $newrelic_log_dir  = '/var/log/newrelic-apm'
  $newrelic_log_name = 'newrelic_agent.log'

  if $app_name == 'adops' {
    $newrelic_app_name  = $adops::newrelic::params::adops_app_name
    $app_folder         = $adops::newrelic::params::adops_app_folder
  } else {
    $newrelic_app_name  = $adops::newrelic::params::pubops_app_name
    $app_folder         = $adops::newrelic::params::pubops_app_folder
  }

  file { $newrelic_log_dir:
    ensure  => directory,
    mode    => '0775',
    owner   => 'apache',
    group   => 'nobody',
  }

  file { "${newrelic_log_dir}/${newrelic_log_name}":
    ensure  => file,
    mode    => '664',
    owner   => 'apache',
    group   => 'nobody',
    require => File[$newrelic_log_dir]
  }

  logrotate::rotate_logs_in_dir { 'newrelic-apm':
    directory => $newrelic_log_dir,
  }

  $newrelic_app_dir     = "${adops::newrelic::params::cap_dir}/${app_folder}"
  $newrelic_app_config  = "${newrelic_app_dir}/shared/config/newrelic.yml"

  file { $newrelic_app_config:
    content => template("adops/newrelic.yml.erb")
  }

}
