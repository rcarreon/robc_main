# used to rotate *log in specified dir
# uses same options as httpd
define logrotate::rotate_logs_in_dir( $directory, $conf_name = $title) {
    $path_safe_conf_name = regsubst($conf_name, '\/', '_', 'G')
    file { "/etc/logrotate.d/$path_safe_conf_name":
        ensure => present,
        owner  => 'root',
        group  => 'root',
        content => template('logrotate/rotate_logs_in_dir.erb'),
    }
}
