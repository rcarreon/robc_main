# This class should actually install Hadoop
class hive::install {

  # hive log dir needs stickky bit set, see:
  # https://cwiki.apache.org/confluence/display/Hive/GettingStarted#GettingStarted-HiveLogging
  file { '/app/log/hive':
    ensure  => directory,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '1755',
    require => File['/app/log'],
  }

  # INSTALL SOFTWARE
  $prefix = '/opt'
  $tmpdir = '/tmp'

  $installed_hive = '/app/data/hadoop/HIVE_INSTALLED'

  # install hive
  exec {'retrieve-hive':
    command => 'wget http://yum.gnmedia.net/puppet-binaries/apache-hive-1.2.1-bin.tar.gz',
    cwd     => $tmpdir,
    creates => "${tmpdir}/apache-hive-1.2.1-bin.tar.gz",
    user    => 'hadoop',
    group   => 'hadoop',
    notify  => Exec['extract-hive'],
    unless  => "test -f ${installed_hive}",
  }->
  exec {'extract-hive':
    command => 'tar xvzf apache-hive-1.2.1-bin.tar.gz',
    cwd     => $tmpdir,
    creates => "${tmpdir}/apache-hive-1.2.1-bin",
    user    => 'hadoop',
    group   => 'hadoop',
    require => Exec['retrieve-hive'],
    notify  => Exec['move-hive'],
    unless  => "test -f ${installed_hive}",
  }->
  exec {'move-hive':
    command => "mv -v ${tmpdir}/apache-hive-1.2.1-bin/ ${prefix}/",
    cwd     => $tmpdir,
    user    => 'root',
    group   => 'root',
    creates => "${prefix}/apache-hive-1.2.1-bin",
    require => Exec['extract-hive'],
    unless  => "test -f ${installed_hive}",
  }->
  file {'/opt/apache-hive':
    ensure  => link,
    target  => 'apache-hive-1.2.1-bin',
    require => Exec['move-hive'],
  }->
  exec {'set-hive-installed':
    command => "touch ${installed_hive}",
    cwd     => $tmpdir,
    user    => 'root',
    group   => 'root',
    creates => "${installed_hive}",
    require => File['/opt/apache-hive'],
  }

  include hive::config

}