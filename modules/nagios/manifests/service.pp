# service things nagios
# http://nagios.sourceforge.net/docs/3_0/objectdefinitions.html#service
define nagios::service ($command,$notes_url,$notifications_enabled='1',$servicegroups='none',$max_check_attempts='3',$normal_check_interval='7',$retry_check_interval='2',$use='generic-service',$notification_options='w,u,c,r,f,s', $notification_period = '24x7', $ensure = 'present', $action_url=undef) {

    @@nagios_service {"${::fqdn}_${name}":
        ensure                => $ensure,
        target                => "/etc/nagios/conf.d/${::fqdn}_${name}.cfg",
        service_description   => $name,
        check_command         => $command,
        host_name             => $::fqdn,
        use                   => $use,
        tag                   => $fqdn_env_full,
        notifications_enabled => $notifications_enabled,
        notification_options  => $notification_options,
        notification_period   => $notification_period,
        max_check_attempts    => $max_check_attempts,
        normal_check_interval => $normal_check_interval,
        retry_check_interval  => $retry_check_interval,
        notes_url             => $notes_url,
        action_url            => $action_url,
    }
}
