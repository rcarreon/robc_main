class newrelic {

    include newrelic::params

    file { $newrelic::params::conf_path:
      ensure => directory,
      mode   => '0755',
      owner  => 'newrelic',
      group  => 'newrelic',
    }
 
    file { $newrelic::params::log_path:
      ensure => directory,
      mode   => '0755',
      owner  => 'newrelic',
      group  => 'newrelic',
    }
    
    logrotate::rotate_logs_in_dir { 'newrelic':
      directory => $newrelic::params::log_path,
    }
}
