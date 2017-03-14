# usage:
# monit::stale_file_check { 'vw_landing_check':
#   stale_file_abs_path   => '/app/data/vwmodels.live/landing.model',
#   stale_file_minutes    => 60,
# }

define monit::stale_file_check ( $stale_file_abs_path, $stale_file_minutes ) {
    require ::monit
    file { "/etc/monit.d/stale_file_check_${title}.conf":
        ensure  => present,
        content => template('monit/stale_file_check.erb'),
        notify  => Service['monit'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
}
