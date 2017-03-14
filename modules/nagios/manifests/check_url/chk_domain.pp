# nagios chk_domain
define nagios::check_url::chk_domain($ip='') {

    # set hostgroup to check_url so we can ignore all the default check
    $hostgroup='check_url'

    file { "/etc/nagios/conf.d/${name}.cfg":
        content => template('nagios/chk_domain.erb'),
        require => Package[nagios],
        notify  => Service[nagios],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
}
