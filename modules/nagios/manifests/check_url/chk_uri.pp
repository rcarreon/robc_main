# nag uri
define nagios::check_url::chk_uri($dom='',$uri_path='',$str='') {

        file { "/etc/nagios/conf.d/${name}.cfg":
                content => template('nagios/chk_uri.erb'),
                require => Package[nagios],
                notify  => Service[nagios],
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
        }
}
