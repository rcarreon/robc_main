# provides ntp for all systems
class ntp {
    package { 'ntp':
        ensure => present,
    }

    service { 'ntpd':
        ensure      => running,
        enable      => true,
        hasstatus   => true,
        require     => Package['ntp'],
    }

    # Used by ntp.conf.erb
    if $::ipaddress_eth1 =~ /^\d+\.\d+\.(\d+)\.\d+/ {
      $third_octet = "$1"
    }

    file {'ntpd_config':
        ensure  => file,
        path    => '/etc/ntp.conf',
        content => template('ntp/ntp.conf.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0664',
        notify  => Service['ntpd'],
        require => Package['ntp'],
    }
    file {'ntp_step_tickers':
        ensure  => file,
        path    => '/etc/ntp/step-tickers',
        source  => 'puppet:///modules/ntp/ntp.step-tickers',
        owner   => 'root',
        group   => 'root',
        mode    => '0664',
        require => Package['ntp'],
    }

    file { 'ntpd_startupconfig':
        ensure  => file,
        path    => '/etc/sysconfig/ntpd',
        source  => 'puppet:///modules/ntp/ntpd-startupconfig',
        owner   => 'root',
        group   => 'root',
        mode    => '0664',
        notify  => Service['ntpd'],
        require => Package['ntp'];
    }
}
