# Spark config file class
class spark::config {
  # spark configs
  file { '/etc/spark':
    ensure  => directory,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0755',
  }->
  # spark-env.sh
  file { '/etc/spark/spark-env.sh':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/spark/spark-env.sh.erb')
  }->
  # log4j.properties
  file { '/etc/spark/log4j.properties':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/spark/log4j.properties')
  }->
  # spark-defaults.conf
  file { '/etc/spark/spark-defaults.conf':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/spark/spark-defaults.conf.erb')
  }->
  # slaves
  file { '/etc/spark/slaves':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/spark/slaves.erb')
  }
  # profile.d settings for spark
  file { '/etc/profile.d/spark.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('techplatform/spark/spark.sh.erb')
  }
  
}
