class ldap::client {

  if ($lsbmajdistrelease == '4') {
    $authconfigoption="--kickstart"
  } else {
    $authconfigoption="--update"
  }

  if ($lsbmajdistrelease == '6') {

    package { 'pam_ldap':
      ensure => present,
    }

    file { '/etc/pam_ldap.conf':
      content => template('ldap/ldap.conf.erb'),
      owner   => root,
      group   => root,
      mode    => 0644,
      require => Package['pam_ldap'],
    }

  } elsif ($lsbmajdistrelease == '5') {

    file { '/etc/ldap.conf':
      content => template('ldap/ldap.conf.erb'),
      owner	=> root,
      group	=> root,
      mode	=> 0644,
    }

  }

  # FIXME : gnlib::replace_line_or_append_if_absent is evil, we must use templates (.erb) instead
  gnlib::replace_line_or_append_if_absent {"SetNISDOMAIN":
    # LDAP nisNetGroup requires this
    file        => "/etc/sysconfig/network",
    pattern     => 'NISDOMAIN=',
    replacement => "NISDOMAIN=gnmedia.net",
  }


  #  The following is needed for the new ldap settings required 
  #  by sssd.  We're omitting Centos 5 machines, as they need 
  #  significant updates in order to have sssd work.

  if ($::lsbmajdistrelease == 6) {

    file { '/etc/openldap/ldap.conf':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/ldap/sssdopenldap.conf',
    }


    file { '/etc/gncerts':
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }

    file { '/etc/gncerts/evmrootca.crt':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['/etc/gncerts'],
        source  => 'puppet:///modules/ldap/evmrootca.crt',
    }


  }


}
