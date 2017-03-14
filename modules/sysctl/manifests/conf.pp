#

# /modules/sysctl/manifests/conf.pp
define sysctl::conf ( $value ) {
#   $name is provided by define invocation
#   guid of this entry

    $key = $name
    $context = '/files/etc/sysctl.conf'

    augeas {"sysctl_conf/${key}":
      context =>  $context,
      onlyif  =>  "get ${key} != '${value}'",
      changes =>  "set ${key} '${value}'",
      notify  =>  Exec['reload_sysctl'],
    }

  $file_name = $::operatingsystem ? {
      redhat  => '/etc/sysctl.conf',
      centos  => '/etc/sysctl.conf',
      default => '/etc/sysctl.conf',
  }

  exec  {'reload_sysctl':
        command     => '/sbin/sysctl -p',
        refreshonly => true
  }

}

