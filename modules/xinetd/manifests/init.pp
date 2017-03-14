# xinetd manifest 
#
class xinetd {
	$project = "admin"

	package { "xinetd":
		ensure => present,
	}

  file { "/etc/xinetd.d":
    ensure	=> directory,
    require	=> Package["xinetd"],
    owner   => "root",
    group   => "root",
    mode    => "0755",
  }
 
  file {"/etc/xinetd.d/README":
    ensure   => absent,
    notify   => Service['xinetd'],
  }

  service { "xinetd":
    enable    => true,
    ensure    => running,
    hasstatus => true,
    require   => File["/etc/xinetd.d"],
  }

    file { "/etc/julien-bombdefuser" :
        ensure => present,
        content => "xinetd restarter",
        notify => Service['xinetd'],
        owner  => "root",
        group  => "root",
        mode   => "0644",
    }


}

# vim: set filetype=puppet expandtab tabstop=2 shiftwidth=2 autoindent smartindent:
