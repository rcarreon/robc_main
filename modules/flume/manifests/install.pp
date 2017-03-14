class flume::install {

  # INSTALL SOFTWARE
  $tmpdir = '/tmp'

  $installed = '/app/data/flume/FLUME_INSTALLED'

  # Install flume
  exec {'retrieve-flume':
    command => 'wget http://yum.gnmedia.net/puppet-binaries/apache-flume-1.6.0-bin.tar.gz',
    cwd     => $tmpdir,
    creates => "${tmpdir}/apache-flume-1.6.0-bin.tar.gz",
    user    => 'flume',
    group   => 'hadoop',
    notify  => Exec['extract-flume'],
    unless  => "test -f ${installed}",
  }->
  exec {'extract-flume':
    command => 'tar xvzf apache-flume-1.6.0-bin.tar.gz',
    cwd     => $tmpdir,
    creates => "${tmpdir}/apache-flume-1.6.0-bin",
    user    => 'hadoop',
    group   => 'hadoop',
    require => Exec['retrieve-flume'],
    notify  => Exec['move-flume'],
    unless  => "test -f ${installed}",
  }->
  exec {'move-flume':
    command => "mv -v ${tmpdir}/apache-flume-1.6.0-bin/ /opt/",
    cwd     => $tmpdir,
    user    => 'root',
    group   => 'root',
    creates => "/opt/apache-flume-1.6.0-bin",
    require => Exec['extract-flume'],
    unless  => "test -f ${installed}",
  }->
  file {'/opt/apache-flume':
    ensure  => link,
    target  => 'apache-flume-1.6.0-bin',
    require => Exec['move-flume'],
  }->
  exec {'retrieve-commonconfig':
    command => 'wget http://yum.gnmedia.net/puppet-binaries/commons-configuration-1.10-bin.tar.gz',
    cwd     => $tmpdir,
    creates => "${tmpdir}/commons-configuration-1.10-bin.tar.gz",
    user    => 'hadoop',
    group   => 'hadoop',
    notify  => Exec['extract-commonconfig'],
    require => File['/opt/apache-flume'],
    unless  => "test -f ${installed}",
  }->
  exec {'extract-commonconfig':
    command => 'tar xvzf commons-configuration-1.10-bin.tar.gz',
    cwd     => $tmpdir,
    creates => "${tmpdir}/commons-configuration-1.10",
    user    => 'hadoop',
    group   => 'hadoop',
    require => Exec['retrieve-commonconfig'],
    unless  => "test -f ${installed}",
  }->
  exec {'copy-commonconfig':
    command => "cp ${tmpdir}/commons-configuration-1.10/*.jar /opt/apache-flume/lib/",
    user    => 'hadoop',
    group   => 'hadoop',
    require => Exec['extract-commonconfig'],
    unless  => "test -f ${installed}",
  }->

  # install hadoop
  exec {'retrieve-hadoop':
    command => 'wget http://yum.gnmedia.net/puppet-binaries/hadoop-2.7.0.tar.gz',
    cwd     => $tmpdir,
    creates => "${tmpdir}/hadoop-2.7.0.tar.gz",
    user    => 'hadoop',
    group   => 'hadoop',
    notify  => Exec['extract-hadoop'],
    unless  => "test -f ${installed}",
  }->
  exec {'extract-hadoop':
    command => 'tar xvzf hadoop-2.7.0.tar.gz',
    cwd     => $tmpdir,
    creates => "${tmpdir}/hadoop-2.7.0",
    user    => 'hadoop',
    group   => 'hadoop',
    require => Exec['retrieve-hadoop'],
    unless  => "test -f ${installed}",
  }->
  exec {'copy-hadoop-bin':
    command => "cp -r ${tmpdir}/hadoop-2.7.0/bin/ /opt/hadoop/",
    user    => 'hadoop',
    group   => 'hadoop',
    unless  => "test -f ${installed}",
  }->
  exec {'copy-common':
    command => "cp ${tmpdir}/hadoop-2.7.0/share/hadoop/common/*.jar /opt/apache-flume/lib/",
    user    => 'hadoop',
    group   => 'hadoop',
    unless  => "test -f ${installed}",
  }->
  exec {'copy-common-lib':
    command => "cp ${tmpdir}/hadoop-2.7.0/share/hadoop/common/lib/*.jar /opt/apache-flume/lib/",
    user    => 'hadoop',
    group   => 'hadoop',
    unless  => "test -f ${installed}",
  }->
  exec {'copy-hdfs':
    command => "cp ${tmpdir}/hadoop-2.7.0/share/hadoop/hdfs/*.jar /opt/apache-flume/lib/",
    user    => 'hadoop',
    group   => 'hadoop',
    unless  => "test -f ${installed}",
  }->
  exec {'copy-mapreduce':
    command => "cp ${tmpdir}/hadoop-2.7.0/share/hadoop/mapreduce/*.jar /opt/apache-flume/lib/",
    user    => 'hadoop',
    group   => 'hadoop',
    unless  => "test -f ${installed}",
  }->
  exec {'copy-yarn':
    command => "cp ${tmpdir}/hadoop-2.7.0/share/hadoop/yarn/*.jar /opt/apache-flume/lib/",
    user    => 'hadoop',
    group   => 'hadoop',
    unless  => "test -f ${installed}",
  }->
  exec {'set-flume-installed':
    command => "touch ${installed}",
    cwd     => $tmpdir,
    user    => 'root',
    group   => 'root',
    creates => "${installed}",
    require => File['/opt/apache-flume'],
  }
}
