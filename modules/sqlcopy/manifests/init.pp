# copy DBs between systems
class sqlcopy {

  package { 'rnetapp':
    ensure => installed,
  }

  # the actual sqlcopy script.
  file { '/usr/local/bin/sqlcopy':
    source => 'puppet:///modules/sqlcopy/sqlcopy',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  # backwards compat
  file { '/usr/local/bin/sqlmulticopy':
    ensure => '/usr/local/bin/sqlcopy',
  }

  # this is where mapfiles will be stored.
  file { '/usr/local/mapfiles':
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  # emblackout bits
  $em_passwd = decrypt('ZUx8C8PemZQMq/MW4xBaOA==')

  file { '/usr/local/bin/emblackout':
    ensure => present,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/sqlcopy/emblackout',
  }

  file { '/etc/emblackout':
    ensure  => present,
    mode    => '0660',
    owner   => 'root',
    group   => 'sysadmins',
    content => "username=em_blackout\npassword=${em_passwd}\n",
  }
}
