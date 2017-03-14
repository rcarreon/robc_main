# This class should actually install Spark
class spark::install {

  # INSTALL SOFTWARE
  $prefix = '/opt'
  $tmpdir = '/tmp'

  $installed = '/app/data/hadoop/SPARK_INSTALLED'
  
  # Install spark
  exec {'retrieve-spark':
    command => 'wget http://yum.gnmedia.net/puppet-binaries/spark-1.6.1-bin-hadoop2.6.tgz',
    cwd     => $tmpdir,
    creates => "${tmpdir}/spark-1.6.1-bin-hadoop2.6.tgz",
    user    => 'hadoop',
    group   => 'hadoop',
    notify  => Exec['extract-spark'],
    unless  => "test -f ${installed}",
  }->
  exec {'extract-spark':
    command => 'tar xvzf spark-1.6.1-bin-hadoop2.6.tgz',
    cwd     => $tmpdir,
    creates => "${tmpdir}/spark-1.6.1-bin-hadoop2.6",
    user    => 'hadoop',
    group   => 'hadoop',
    require => Exec['retrieve-spark'],
    notify  => Exec['move-spark'],
    unless  => "test -f ${installed}",
  }->
  exec {'move-spark':
    command => "mv -v ${tmpdir}/spark-1.6.1-bin-hadoop2.6/ ${prefix}/",
    cwd     => $tmpdir,
    user    => 'root',
    group   => 'root',
    creates => "${prefix}/spark-1.6.1-bin-hadoop2.6",
    require => Exec['extract-spark'],
    unless  => "test -f ${installed}",
  }->
  file {'/opt/spark':
    ensure  => link,
    target  => 'spark-1.6.1-bin-hadoop2.6',
    require => Exec['move-spark'],
  }->
  exec {'set-spark-installed':
    command => "touch ${installed}",
    cwd     => $tmpdir,
    user    => 'root',
    group   => 'root',
    creates => "${installed}",
    require => File['/opt/spark'],
  }

}
