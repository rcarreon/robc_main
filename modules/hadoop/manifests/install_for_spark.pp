# This class should actually install Hadoop
class hadoop::install_for_spark {

  # INSTALL SOFTWARE
  $prefix = '/opt'
  $tmpdir = '/tmp'

  $installed = '/app/data/hadoop/HADOOP_INSTALLED'

  file { '/opt/hadoop':
    ensure  => directory,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0775',
  }

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
  exec {'copy-hadoop-libexec':
    command => "cp -r ${tmpdir}/hadoop-2.7.0/libexec/ /opt/hadoop/",
    user    => 'hadoop',
    group   => 'hadoop',
    unless  => "test -f ${installed}",
  }->
  exec {'copy-hadoop-share':
    command => "cp -r ${tmpdir}/hadoop-2.7.0/share/ /opt/hadoop/",
    user    => 'hadoop',
    group   => 'hadoop',
    unless  => "test -f ${installed}",
  }->
  exec {'copy-common':
    command => "cp ${tmpdir}/hadoop-2.7.0/share/hadoop/common/*.jar /opt/spark/lib/",
    user    => 'hadoop',
    group   => 'hadoop',
    unless  => "test -f ${installed}",
  }->
  exec {'copy-common-lib':
    command => "cp ${tmpdir}/hadoop-2.7.0/share/hadoop/common/lib/*.jar /opt/spark/lib/",
    user    => 'hadoop',
    group   => 'hadoop',
    unless  => "test -f ${installed}",
  }->
  exec {'copy-hdfs':
    command => "cp ${tmpdir}/hadoop-2.7.0/share/hadoop/hdfs/*.jar /opt/spark/lib/",
    user    => 'hadoop',
    group   => 'hadoop',
    unless  => "test -f ${installed}",
  }->
  exec {'copy-mapreduce':
    command => "cp ${tmpdir}/hadoop-2.7.0/share/hadoop/mapreduce/*.jar /opt/spark/lib/",
    user    => 'hadoop',
    group   => 'hadoop',
    unless  => "test -f ${installed}",
  }->
  exec {'copy-yarn':
    command => "cp ${tmpdir}/hadoop-2.7.0/share/hadoop/yarn/*.jar /opt/spark/lib/",
    user    => 'hadoop',
    group   => 'hadoop',
    unless  => "test -f ${installed}",
  }
}