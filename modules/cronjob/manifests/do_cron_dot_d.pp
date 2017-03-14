# use do_cron_dot_d for /etc/cron.d, use this one if you have 1 .cron to exec 1 script
# default path to the $script is /usr/local/bin
# if $script_path exist, full path will be /usr/local/bin/$script_path

define cronjob::do_cron_dot_d ($script) {

  if $script_path != '' {
    file { "/etc/cron.d/${name}":
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => "puppet:///modules/cronjob/cron.d/${script_path}/${name}",
    }

    file { "/usr/local/bin/${script_path}/${script}":
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0744',
      source  => "puppet:///modules/cronjob/cron.d/${script_path}/${script}",
    }
  } else {
    file { "/etc/cron.d/${name}":
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => "puppet:///modules/cronjob/cron.d/${name}",
    }

    file { "/usr/local/bin/${script}":
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0744',
      source  => "puppet:///modules/cronjob/cron.d/${script}",
    }
  }
}
