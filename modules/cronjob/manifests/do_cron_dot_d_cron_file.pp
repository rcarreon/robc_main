# $script_path uses to organize the dir/file in files/cron.*.  ie. files/cron.hourly/crowdignite_engine/
define cronjob::do_cron_dot_d_cron_file () {
  if $script_path != '' {
    file { "/etc/cron.d/${name}":
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => "puppet:///modules/cronjob/cron.d/${script_path}/${name}",
    }
  } else {
    file { "/etc/cron.d/${name}":
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => "puppet:///modules/cronjob/cron.d/${name}",
    }
  }
}
