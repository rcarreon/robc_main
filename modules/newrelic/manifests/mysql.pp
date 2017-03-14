# vim: set ts=2 sw=2 et :
# Install NewRelic NPI MySQL plugin
class newrelic::mysql {
  include newrelic::params
  include newrelic::plugins

  $categories = 'status,newrelic,master,slave,buffer_pool_stats,innodb_status'

  class { 'java': distribution => 'jre' }->
  class { 'newrelic_plugins::mysql':
    license_key   => $newrelic::params::license,
    install_path  => "${newrelic::params::plugin_path}",
    user          => $newrelic::params::system_user,
    java_options  => '-Xmx128m',
    servers       => [
      {
        name           => $::fqdn,
        host           => $::fqdn,
        metrics        => $categories,
        mysql_user     => 'newrelic',
        mysql_passwd   => decrypt("emkzyktj6GdUDgWPImCdQw=="),
      }
    ],
  }

  logrotate::rotate_logs_in_dir { 'newrelic-mysql-plugin':
    directory => "${newrelic::params::plugin_path}/newrelic_mysql_plugin/logs",
  }
}
