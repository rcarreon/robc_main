class net_snmp::service {
    # All the services below must be restarted if varnish.vcl changes
    Service {
        require    => Class['net_snmp'],
        enable     => true,
        ensure     => running,
        hasstatus  => true,
        hasrestart => true,
        subscribe  => File['/etc/snmp/snmpd.conf'],
    }
    # main service, running the reverse proxy
    service {'snmpd':}
}
