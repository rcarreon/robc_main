# This class should actually install Hadoop
class hadoop::install {

  # INSTALL SOFTWARE
  $prefix = '/opt'
  $tmpdir = '/tmp'

  $installed = '/app/data/hadoop/HADOOP_INSTALLED'
  
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
    notify  => Exec['move-hadoop'],
    unless  => "test -f ${installed}",
  }->
  exec {'move-hadoop':
    command => "mv -v ${tmpdir}/hadoop-2.7.0/ ${prefix}/",
    cwd     => $tmpdir,
    user    => 'root',
    group   => 'root',
    creates => "${prefix}/hadoop-2.7.0",
    require => Exec['extract-hadoop'],
    unless  => "test -f ${installed}",
  }->
  file {'/opt/hadoop':
    ensure  => link,
    target  => 'hadoop-2.7.0',
    require => Exec['move-hadoop'],
  }->
  exec {'set-hadoop-installed':
    command => "touch ${installed}",
    cwd     => $tmpdir,
    user    => 'root',
    group   => 'root',
    creates => "${installed}",
    require => File['/opt/hadoop'],
  }

}
