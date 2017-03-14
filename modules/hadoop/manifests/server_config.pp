# Hadoop config file class
class hadoop::server_config inherits hadoop::client_config{

  # capacity-scheduler.xml
  file { '/etc/hadoop/capacity-scheduler.xml':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/capacity-scheduler.xml')
  }

  # container-executor.cfg
  file { '/etc/hadoop/container-executor.cfg':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/container-executor.cfg')
  }

  # hadoop-metrics2.properties
  file { '/etc/hadoop/hadoop-metrics2.properties':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/hadoop-metrics2.properties.erb')
  }

  # hadoop-metrics.properties
  file { '/etc/hadoop/hadoop-metrics.properties':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/hadoop-metrics.properties')
  }

  # hadoop-policy.xml
  file { '/etc/hadoop/hadoop-policy.xml':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/hadoop-policy.xml')
  }

  # httpfs-env.sh
  file { '/etc/hadoop/httpfs-env.sh':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/httpfs-env.sh.erb')
  }

  # httpfs-site.xml
  file { '/etc/hadoop/httpfs-site.xml':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/httpfs-site.xml.erb')
  }

  # httpfs-log4j.properties
  file { '/etc/hadoop/httpfs-log4j.properties':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/httpfs-log4j.properties')
  }

  # httpfs-signature.secret
  file { '/etc/hadoop/httpfs-signature.secret':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/httpfs-signature.secret')
  }

  # kms-acls.xml
  file { '/etc/hadoop/kms-acls.xml':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/kms-acls.xml')
  }

  # kms-env.sh
  file { '/etc/hadoop/kms-env.sh':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/kms-env.sh')
  }

  # kms-log4j.properties
  file { '/etc/hadoop/kms-log4j.properties':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/kms-log4j.properties')
  }

  # kms-site.xml
  file { '/etc/hadoop/kms-site.xml':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/kms-site.xml')
  }

  # log4j.properties
  file { '/etc/hadoop/log4j.properties':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/log4j.properties')
  }

  # mapred-env.sh
  file { '/etc/hadoop/mapred-env.sh':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/mapred-env.sh')
  }

  # master
  file { '/etc/hadoop/master':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/master.erb')
  }

  # slaves
  file { '/etc/hadoop/slaves':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/slaves.erb')
  }

  # datanode hosts
  file { '/etc/hadoop/hosts.txt':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/hosts.txt.erb')
  }

  # Decommissed hosts
  file { '/etc/hadoop/decommissed_host.txt':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/decommissed_host.txt')
  }

  # hadoop-cluster.sh
  file { '/etc/init.d/hadoop-cluster':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content  => template('techplatform/hadoop/hadoop-cluster.sh')
  }

  # start-hdfs.sh
  file { '/opt/hadoop/sbin/start-hdfs.sh':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0755',
    content  => template('techplatform/hadoop/start-hdfs.sh')
  }

  # stop-hdfs.sh
  file { '/opt/hadoop/sbin/stop-hdfs.sh':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0755',
    content  => template('techplatform/hadoop/stop-hdfs.sh')
  }

}
