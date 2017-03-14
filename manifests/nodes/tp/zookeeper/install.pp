class zookeeper::install {
  # zookeeper data
  file { '/app/data/zookeeper':
    ensure  => directory,
    owner   => 'zookeeper',
    group   => 'hadoop',
    mode    => '0755',
  }->
  # myid file
  file { '/app/data/zookeeper/myid':
    ensure  => file,
    owner   => 'zookeeper',
    group   => 'hadoop',
    mode    => '0644',
    content => $::fqdn_incr,
  }

  # zookeeper data
  file { '/app/log/zookeeper':
    ensure  => directory,
    owner   => 'zookeeper',
    group   => 'hadoop',
    mode    => '0755',
  }

  # INSTALL SOFTWARE
  $prefix = '/opt'
  $tmpdir = '/tmp'

  $installed = '/app/data/zookeeper/ZK_INSTALLED'

  # install zookeeper
  exec {'retrieve-zookeeper':
    command => 'wget http://yum.gnmedia.net/puppet-binaries/zookeeper-3.4.8.tar.gz',
    cwd     => $tmpdir,
    creates => "${tmpdir}/zookeeper-3.4.8.tar.gz",
    user    => 'zookeeper',
    group   => 'hadoop',
    notify  => Exec['extract-zookeeper'],
    unless  => "test -f ${installed}",
  }->
  exec {'extract-zookeeper':
    command => 'tar xvzf zookeeper-3.4.8.tar.gz ',
    cwd     => $tmpdir,
    creates => "${tmpdir}/zookeeper-3.4.8",
    user    => 'zookeeper',
    group   => 'hadoop',
    require => Exec['retrieve-zookeeper'],
    notify  => Exec['move-zookeeper'],
    unless  => "test -f ${installed}",
  }->
  exec {'move-zookeeper':
    command => "mv -v ${tmpdir}/zookeeper-3.4.8/ ${prefix}/",
    cwd     => $tmpdir,
    user    => 'root',
    group   => 'root',
    creates => "${prefix}/zookeeper-3.4.8",
    require => Exec['extract-zookeeper'],
    unless  => "test -f ${installed}",
  }->
  file {'/opt/zookeeper':
    ensure  => link,
    target  => 'zookeeper-3.4.8',
    require => Exec['move-zookeeper'],
  }->
  exec {'set-zookeeper-installed':
    command => "touch ${installed}",
    cwd     => $tmpdir,
    user    => 'root',
    group   => 'root',
    creates => "${installed}",
    require => File['/opt/zookeeper'],
  }
}