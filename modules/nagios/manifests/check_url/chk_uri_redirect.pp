# nag uri redirect
define nagios::check_url::chk_uri_redirect($dom='',$uri_path='',$str='') {

        file { "/etc/nagios/conf.d/${name}.cfg":
                content => template('nagios/chk_uri_redirect.erb'),
                require => Package[nagios],
                notify  => Service[nagios],
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
        }
}
