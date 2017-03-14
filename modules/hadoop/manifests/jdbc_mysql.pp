# JDBC driver for mysql server
class hadoop::jdbc_mysql ($path = '/opt/spark/lib') {
  
  # MySQL Connector
  exec {'retrieve-jdbc-mysql':
    command => 'wget http://yum.gnmedia.net/puppet-binaries/mysql-connector-java-5.1.36-bin.jar',
    cwd     => $path,
    creates => "${path}/mysql-connector-java-5.1.36-bin.jar",
    user    => 'hadoop',
    group   => 'hadoop',
    unless  => "test -f ${path}/mysql-connector-java-5.1.36-bin.jar"
  }->

  file {"${path}/mysql-connector-java-5.1.36-bin.jar":
    require => Exec['retrieve-jdbc-mysql'],
    mode    => '0644'
  }->

  file {"${path}/mysql-connector-java.jar":
    ensure  => link,
    target  => 'mysql-connector-java-5.1.36-bin.jar',
    require => File["${path}/mysql-connector-java-5.1.36-bin.jar"]
  }

}
