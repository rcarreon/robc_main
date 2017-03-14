# nag about xml
define nagios::check_url::check_url_xml($dom='',$full_url='',$num_retries='1',$extra_opts='') {

        file { "/etc/nagios/conf.d/${name}.cfg":
                content => template('nagios/check_url_xml.erb'),
                require => Package[nagios],
                notify  => Service[nagios],
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
        }
}
