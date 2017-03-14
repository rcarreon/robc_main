# host things nagios
# http://nagios.sourceforge.net/docs/3_0/objectdefinitions.html#host
define nagios::host ($use='generic-host') {
    if ($at_vertical != '') {
        $hostgroup=$at_vertical
    } else {
        $hostgroup='no-vertical-defined'
    }

    $mod_fqdn = regsubst($::fqdn,'\.','_','G')
    $cgp_url = "http://gweb.gnmedia.net/?h=${::fqdn}"
    @@nagios_host { $name:
        ensure                => present,
        target                => "/etc/nagios/conf.d/${::fqdn}.cfg",
        use                   => $use,
        host_name             => $::fqdn,
        hostgroups            => $hostgroup,
        alias                 => $::fqdn,
        address               => $ipaddress,
        notification_interval => 60,
        notes_url             => $cgp_url,
        tag                   => $fqdn_env_full,
    }
}
