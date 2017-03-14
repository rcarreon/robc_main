# iscsi multipath defined type
define iscsi::multipath ($mp_wwid, $mp_alias) {
    package { 'device-mapper-multipath':
        ensure=>'installed',
    }
    file {'/etc/multipath.conf':
        content => template('iscsi/multipath.conf.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['device-mapper-multipath'],
    }
    file {'/etc/rc.d/init.d/lvm-mp-stop':
        source  => 'puppet:///modules/iscsi/lvm-mp-stop',
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        notify  => Exec['lvm-mp-stopadd'],
    }
    exec { 'lvm-mp-stopadd':
        command     => '/sbin/chkconfig --add lvm-mp-stop',
        require     => [File['/etc/rc.d/init.d/lvm-mp-stop'],],
        notify      => Exec['lvm-mp-stopon'],
        refreshonly => true,
    }

    exec { 'lvm-mp-stopon':
        command     => '/sbin/chkconfig lvm-mp-stop on',
        require     => [File['/etc/rc.d/init.d/lvm-mp-stop'],],
        refreshonly => true,
    }
}
