# nagios server plugins
class nagios::server::plugins {
    include aceman::nagios

  # Each plugin has its own package...
  # installs nagios-devel package$
  package { "nagios-devel.${::architecture}":
    ensure  => present,
    require => Package['nagios'],
  }

  # installs nagios-plugins package$
  package { 'nagios-plugins':
    ensure  => present,
    require => Package['nagios'],
  }
  #
    # installs nagios-plugins-dhcp package$
  package { 'nagios-plugins-dhcp':
    ensure   => present,
    require  => Package['nagios-plugins'],
  }
  # installs nagios-plugins-dns package$
  package { 'nagios-plugins-dns':
    ensure   => present,
    require  => Package['nagios-plugins'],
  }
  # installs nagios-plugins-ldap package$
  package { 'nagios-plugins-ldap':
    ensure   => present,
    require  => Package['nagios-plugins'],
  }
  # installs nagios-plugins-mysql package$
  package { 'nagios-plugins-mysql':
    ensure   => present,
    require  => Package['nagios-plugins'],
  }
  # installs nagios-plugins-nagios package$
  package { 'nagios-plugins-nagios':
    ensure   => present,
    require  => Package['nagios-plugins'],
  }
  # installs nagios-plugins-perl package$
  package { 'nagios-plugins-perl':
    ensure   => present,
    require  => Package['nagios-plugins'],
  }
  # installs nagios-plugins-ping package$
  package { 'nagios-plugins-ping':
    ensure   => present,
    require  => Package['nagios-plugins'],
  }
  # installs nagios-plugins-smtp package$
  package { 'nagios-plugins-smtp':
    ensure   => present,
    require  => Package['nagios-plugins'],
  }
  # installs nagios-plugins-snmp package$
  package { 'nagios-plugins-snmp':
    ensure   => present,
    require  => Package['nagios-plugins'],
  }
  # installs nagios-plugins-ssh package$
  package { 'nagios-plugins-ssh':
    ensure   => present,
    require  => Package['nagios-plugins'],
  }
  # installs nagios-plugins-tcp package$
  package { 'nagios-plugins-tcp':
    ensure   => present,
    require  => Package['nagios-plugins'],
  }
    # required for check_monit
    # package { "python-elementtree":
    #    ensure  => present,
    # }   $
    # required for check_netapp
    package { 'perl-Net-SNMP':
        ensure  => present,
    }

    # required for check_http_json.rb
    package {'rubygem-json':
        ensure => present,
    }
    # required for check_vw.sh
    package {'nc':
        ensure => present,
    }
}
