# directories needed for adops
class adops::newrelic::mysql($host) {

  include adops::newrelic::params

  $categories = 'status,newrelic,master,slave,buffer_pool_stats,innodb_status'

  $newrelic_user = $adops::newrelic::params::user

  user { $newrelic_user:
    ensure     => present,
    membership => minimum,
    shell      => "/bin/bash",
  }->
  file { $adops::newrelic::params::base_path:
    ensure  => directory,
    mode    => '0755',
    owner   => $newrelic_user,
    group   => $newrelic_user,
  }->
  class { 'java':
    distribution => 'jre',
    }->
    class { 'newrelic_plugins::mysql':
      license_key    => $adops::newrelic::params::license,
      install_path   => "${$adops::newrelic::params::base_path}/newrelic-npi",
      user           => 'newrelic',
      java_options   => '-Xmx128m',
      servers        => [
        {
          name           => $host,
          host           => $host,
          metrics        => $categories,
          mysql_user     => 'newrelic',
          mysql_passwd   => decrypt("emkzyktj6GdUDgWPImCdQw=="),
        }
      ]
    }

  $mysql_npi_path = 'newrelic-npi/newrelic_mysql_plugin'
  logrotate::rotate_logs_in_dir { 'newrelic-apm':
    directory => "#{$adops::newrelic::params::base_path}/#{$mysql_npi_path}",
  }

}
