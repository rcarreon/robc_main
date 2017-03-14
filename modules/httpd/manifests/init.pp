# Class: httpd

class httpd inherits httpd::base {

    $mod_fqdn = regsubst($::fqdn,'\.','_','G')
    $mod_url = "http://graphite.gnmedia.net/render/?width=586&height=308&_salt=1344035251.282&target=${mod_fqdn}.load.load.shortterm"

    # and we will make sure the default vhost (with up) is running properly
        if ($::httpd != 'sorry-farm' ) {
            nagios::service {'httpd':
                command               => "check_url!${ipaddress}!/!up",
                notes_url             => 'http://docs.gnmedia.net/wiki/Nagios-check_url',
                action_url            => "http://gweb.gnmedia.net/?h=${::fqdn}$&r=hour&metric_group=NOGROUPS&z=small",
                normal_check_interval => '3',
            }
        }


}
