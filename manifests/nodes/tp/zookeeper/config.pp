class zookeeper::config {
  file { '/etc/zookeeper':
    ensure  => directory,
    owner   => 'zookeeper',
    group   => 'hadoop',
    mode    => '0755',
  }->
  file { '/etc/zookeeper/zoo.cfg':
    ensure  => file,
    owner   => 'zookeeper',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/zookeeper/zoo.cfg.erb')
  }
  file { '/etc/zookeeper/configuration.xsl':
    ensure  => file,
    owner   => 'zookeeper',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/zookeeper/configuration.xsl')
  }
  file { '/etc/zookeeper/log4j.properties':
    ensure  => file,
    owner   => 'zookeeper',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/zookeeper/log4j.properties')
  }
  file { '/etc/profile.d/zookeeper.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('techplatform/zookeeper/zookeeper.sh')
  }
  file { '/etc/init.d/zookeeper-cluster':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('techplatform/zookeeper/zookeeper-cluster.sh')
  }

}
