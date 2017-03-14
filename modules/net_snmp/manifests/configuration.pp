class net_snmp::configuration{
    File {
        ensure => present,
        owner  => 'root',
        group  => 'root',
    }

    file { '/etc/snmp/snmpd.conf':
        ensure  => file,
        mode    => '0755',
        source  => 'puppet:///modules/net_snmp/snmpd.conf',
        require => Class['net_snmp::install'],
        notify  => Class['net_snmp::service'],
    }

    file { '/etc/sysconfig/snmpd.options':
        ensure  => file,
        mode    => '0644',
        source  => 'puppet:///modules/net_snmp/snmpd.options',
        require => Class['net_snmp::install'],
        notify  => Class['net_snmp::service'],
    }
}
