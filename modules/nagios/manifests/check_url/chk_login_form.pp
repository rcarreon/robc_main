# nag about login forms
define nagios::check_url::chk_login_form($dom='',$full_url='',$auth='',$str='') {

        file { "/etc/nagios/conf.d/${name}.cfg":
                content     => template('nagios/chk_login_form.erb'),
                require     => Package[nagios],
                notify      => Service[nagios],
                owner       => 'root',
                group       => 'root',
                mode        => '0644',
        }
}
