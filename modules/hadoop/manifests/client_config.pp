# Hadoop config file class
class hadoop::client_config inherits hadoop {

  file { '/etc/hadoop':
    ensure  => directory,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0755',
  }

  # configuration.xsl
  file { '/etc/hadoop/configuration.xsl':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/configuration.xsl')
  }

  # hadoop-env.sh
  file { '/etc/hadoop/hadoop-env.sh':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/hadoop-env.sh.erb')
  }

  # core-site.xml
  file { '/etc/hadoop/core-site.xml':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/core-site.xml.erb')
  }

  # hdfs-site.xml
  file { '/etc/hadoop/hdfs-site.xml':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/hdfs-site.xml.erb')
  }

  # profile.d settings for Hadoop
  file { '/etc/profile.d/hadoop.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('techplatform/hadoop/env-hadoop.sh.erb')
  }

  # mapred-site.xml
  file { '/etc/hadoop/mapred-site.xml':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/mapred-site.xml.erb')
  }

  # yarn-site.xml
  file { '/etc/hadoop/yarn-site.xml':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/yarn-site.xml.erb')
  }

  # yarn-env.sh
  file { '/etc/hadoop/yarn-env.sh':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/yarn-env.sh')
  }
  
}
