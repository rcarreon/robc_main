
#/modules/sysctl/manifests/init.pp
class sysctl {
  file  {'sysctl_config':
    ensure => 'file',
    path   => '/etc/sysctl.conf',
    source => 'puppet:///modules/sysctl/sysctl.conf',
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

