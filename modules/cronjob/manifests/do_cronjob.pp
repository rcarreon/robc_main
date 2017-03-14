# use do_cronjob for cron.hourly, cron.daily, cron.weekly, cron.monthly
# $script_path uses to organize the dir/file in files/cron.*.  ie. files/cron.hourly/crowdignite_engine/
# but it will never put the actual script into the path in /etc/cron.*/<path>

define cronjob::do_cronjob ($cron_folder) {

  if $cron_folder =~ /^cron\.(hourly|daily|weekly|monthly)/ {
    if $script_path != '' {
      file { "/etc/${cron_folder}/${name}":
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => "puppet:///modules/cronjob/${cron_folder}/${script_path}/${name}",
      }
    } else {
      file { "/etc/${cron_folder}/${script}":
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => "puppet:///modules/cronjob/${cron_folder}/${name}",
      }
    }
  }
}
