# putting scripts in their place
define cronjob::do_cron_dot_d_script () {
  if $script_path != '' {
    file { "/usr/local/bin/${script_path}/${name}":
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      source  => "puppet:///modules/cronjob/cron.d/${script_path}/${name}",
    }
  } else {
    file { "/usr/local/bin/${name}":
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => "puppet:///modules/cronjob/cron.d/${name}",
    }
  }
}
