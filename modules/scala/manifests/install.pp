# This class should actually install Scala
class scala::install inherits scala {

  # Install scala
  exec {'retrieve-scala':
    command => 'wget http://yum.gnmedia.net/puppet-binaries/scala-2.12.0-M3.tgz',
    cwd     => $tmpdir,
    creates => "${tmpdir}/scala-2.12.0-M3.tgz",
    user    => 'hadoop',
    group   => 'hadoop',
    notify  => Exec['extract-spark'],
    unless  => "test -f ${installed}",
  }->
  exec {'extract-scala':
    command => 'tar xvzf scala-2.12.0-M3.tgz',
    cwd     => $tmpdir,
    creates => "${tmpdir}/scala-2.12.0-M3",
    user    => 'hadoop',
    group   => 'hadoop',
    require => Exec['retrieve-spark'],
    notify  => Exec['move-spark'],
    unless  => "test -f ${installed}",
  }->
  exec {'move-scala':
    command => "mv -v ${tmpdir}/scala-2.12.0-M3/ ${prefix}/",
    cwd     => $tmpdir,
    user    => 'root',
    group   => 'root',
    creates => "${prefix}/scala-2.12.0-M3",
    require => Exec['extract-spark'],
    unless  => "test -f ${installed}",
  }->
  file {'/opt/scala':
    ensure  => link,
    target  => 'scala-2.12.0-M3',
    require => Exec['move-spark'],
  }->
  exec {'set-scala-installed':
    command => "touch ${installed}",
    cwd     => $tmpdir,
    user    => 'root',
    group   => 'root',
    creates => "${installed}",
    require => File['/opt/scala'],
  }
}

