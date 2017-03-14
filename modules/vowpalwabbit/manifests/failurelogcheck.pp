# usage:
# vowpalwabbit::failurelogcheck { '/app/log/vw_widget-error_log': }
# vowpalwabbit::failurelogcheck { '/app/log/vw_widget-error_log': 
#   failurelog_owner    => 'nobody',
#   failurelog_group    => 'root',
#   failurelog_mode     => 0644,
# }

define vowpalwabbit::failurelogcheck ( $failurelog_owner = 'apache', $failurelog_group = 'apache', $failurelog_mode = 0644 ) {

    file { "$title":
        ensure  => file,
        owner   => "${failurelog_owner}",
        group   => "${failurelog_group}",
        mode    => "${failurelog_mode}",
    }

    # prevent '/' in service check names
    $path_safe_title = regsubst($title, '\/', '_', 'G')
    nagios::service { "check_vw_failurelog_$path_safe_title":
        command                 => "check_nrpe_args!check_failurelog!vw_is_failing!${title}",
        normal_check_interval   => 30,
        max_check_attempts      => 1,
        notes_url               => 'http://docs.gnmedia.net/wiki/Nagios-check_vw_failurelog',
        require                 => File["$title"],
    }
}
