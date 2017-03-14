class sysctl::default {
  file  {'sysctl_config':
    ensure => 'present',
    path   => '/etc/sysctl.conf',
    source => 'puppet:///modules/sysctl/sysctl_default.conf',
    owner  => 'root',
    group  => 'root',
    mode   => '0664',
    notify => Exec['reload-sysctl']
  }

  exec  {'reload-sysctl':
        command     => '/sbin/sysctl -p',
        refreshonly => true
  }
}
