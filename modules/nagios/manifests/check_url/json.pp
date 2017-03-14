# check json url
define nagios::check_url::json($dom='',$url=''){
    file { "/etc/nagios/conf.d/${name}.cfg":
        content => template('nagios/check_url_json.erb'),
        require => Package[nagios],
        notify  => Service[nagios],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
}
