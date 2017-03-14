# Hive config file class
class hive::config {

  $mysql_hive_user = decrypt('c4nFeTvHZVouXmbTBRtVfw==')

  # hive configs
  file { '/etc/hive':
    ensure  => directory,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0755',
  }->

  # configuration.xsl
  file { '/etc/hive/configuration.xsl':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hive/configuration.xsl')
  }->

  # hive-site.xml
  file { '/etc/hive/hive-site.xml':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hive/hive-site.xml.erb')
  }->
  # hive-log4j.properties
  file { '/etc/hive/hive-log4j.properties':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hive/hive-log4j.properties')
  }->
  # hive-exec-log4j.properties
  file { '/etc/hive/hive-exec-log4j.properties':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hive/hive-exec-log4j.properties')
  }->
  # .hiverc
  file { '/etc/hive/.hiverc':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hive/.hiverc')
  }->
  # profile.d settings for Hive
  file { '/etc/profile.d/hive.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('techplatform/hive/env-hive.sh.erb')
  }
  # hive-services.sh
  file { '/etc/init.d/hive-services':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content  => template('techplatform/hive/hive-services.sh')
  }

  # External libraries

  exec {'retrieve-jdbc-mysql':
    command => 'wget http://yum.gnmedia.net/puppet-binaries/mysql-connector-java-5.1.36-bin.jar',
    cwd     => '/opt/apache-hive/lib/',
    creates => '/opt/apache-hive/lib/mysql-connector-java-5.1.36-bin.jar',
    user    => 'hadoop',
    group   => 'hadoop',
    unless  => 'test -f /opt/apache-hive/lib/mysql-connector-java-5.1.36-bin.jar'
  }->

  file {'/opt/apache-hive/lib/mysql-connector-java-5.1.36-bin.jar':
    require => Exec['retrieve-jdbc-mysql'],
    mode    => '0644'
  }->

  file {'/opt/apache-hive/lib/mysql-connector-java.jar':
    ensure  => link,
    target  => 'mysql-connector-java-5.1.36-bin.jar',
    require => File['/opt/apache-hive/lib/mysql-connector-java-5.1.36-bin.jar']
  }

  exec {'retrieve-hive-json':
    command => 'wget http://yum.gnmedia.net/puppet-binaries/hive-json-serde-0.2.jar',
    cwd     => '/opt/apache-hive/lib/',
    creates => '/opt/apache-hive/lib/hive-json-serde-0.2.jar',
    user    => 'hadoop',
    group   => 'hadoop',
    unless  => 'test -f /opt/apache-hive/lib/hive-json-serde-0.2.jar'
  }->

  file {'/opt/apache-hive/lib/hive-json-serde-0.2.jar':
    require => Exec['retrieve-hive-json'],
    mode    => '0644'
  }

}
