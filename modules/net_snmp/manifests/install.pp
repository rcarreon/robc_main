class net_snmp::install {
    package { 'net-snmp':
        ensure => installed,
    }
    package { 'net-snmp-utils':
        ensure => installed,
    }
}

