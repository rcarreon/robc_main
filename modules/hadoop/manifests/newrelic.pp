# This class should install new relic libraries for hadoop
class hadoop::newrelic {

  $hadoop_libraries = '/opt/hadoop/share/hadoop/common/lib'
  $newrelic_installed = '/app/data/hadoop/NEWRELIC_INSTALLED'  

  # install logback libraries
  exec {'retrieve-logback-core':
    command => 'wget http://yum.gnmedia.net/puppet-binaries/logback-core-1.1.3.jar',
    cwd     => $hadoop_libraries,
    creates => "${hadoop_libraries}/logback-core-1.1.3.jar",
    user    => 'hadoop',
    group   => 'hadoop',
    notify  => Exec['retrieve-logback-classic'],
    unless  => "test -f ${newrelic_installed}",
  }->

  exec {'retrieve-logback-classic':
    command => 'wget http://yum.gnmedia.net/puppet-binaries/logback-classic-1.1.3.jar',
    cwd     => $hadoop_libraries,
    creates => "${hadoop_libraries}/logback-classic-1.1.3.jar",
    user    => 'hadoop',
    group   => 'hadoop',
    notify  => Exec['retrieve-logback-access'],
    unless  => "test -f ${newrelic_installed}",
  }->

  exec {'retrieve-logback-access':
    command => 'wget http://yum.gnmedia.net/puppet-binaries/logback-access-1.1.3.jar',
    cwd     => $hadoop_libraries,
    creates => "${hadoop_libraries}/logback-access-1.1.3.jar",
    user    => 'hadoop',
    group   => 'hadoop',
    notify  => Exec['retrieve-newrelic'],
    unless  => "test -f ${newrelic_installed}",
  }->

  exec {'retrieve-newrelic':
    command => 'wget http://yum.gnmedia.net/puppet-binaries/newrelic_hadoop_plugin.jar',
    cwd     => $hadoop_libraries,
    creates => "${hadoop_libraries}/newrelic_hadoop_plugin.jar",
    user    => 'hadoop',
    group   => 'hadoop',
    notify  => Exec['retrieve-json-simple'],
    unless  => "test -f ${newrelic_installed}",
  }->

  exec {'retrieve-json-simple':
    command => 'wget http://yum.gnmedia.net/puppet-binaries/json-simple-1.1.1.jar',
    cwd     => $hadoop_libraries,
    creates => "${hadoop_libraries}/json-simple-1.1.1.jar",
    user    => 'hadoop',
    group   => 'hadoop',
    unless  => "test -f ${newrelic_installed}",
  }->

  exec {'set-newrelic-installed':
    command => "touch ${newrelic_installed}",
    user    => 'root',
    group   => 'root',
    creates => "${newrelic_installed}",
  }

}