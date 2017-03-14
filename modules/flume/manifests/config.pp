class flume::config {
  group { 'hadoop':
    ensure => 'present',
    gid => '10318',
  }
  user { 'flume':
    ensure   => 'present',
    home     => '/',
    comment  => 'Flume user',
    password => '!!',
    gid      => 'hadoop',
    require  => Group["hadoop"],
  }

  $mydomain = $::domain

  file { '/etc/apache-flume':
    ensure  => directory,
    owner   => 'flume',
    group   => 'hadoop',
    mode    => '0755',
  }->
  # profile.d settings for apache-flume-env.sh
  file { '/etc/profile.d/apache-flume.sh':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("techplatform/apache-flume/$mydomain/env-apache-flume.sh.erb")
  }->
  # flume-conf
  file { '/etc/apache-flume/flume.conf':
      ensure  => file,
      owner   => 'flume',
      group   => 'hadoop',
      mode    => '0644',
      content => template("techplatform/apache-flume/$mydomain/flume.conf.erb")
  }->
  # flume-conf.properties
  file { '/etc/apache-flume/flume-conf.properties':
      ensure  => file,
      owner   => 'flume',
      group   => 'hadoop',
      mode    => '0644',
      content => template("techplatform/apache-flume/$mydomain/flume-conf.properties")
  }->
  # flume-env.ps1
  file { '/etc/apache-flume/flume-env.sh':
      ensure  => file,
      owner   => 'flume',
      group   => 'hadoop',
      mode    => '0644',
      content => template("techplatform/apache-flume/$mydomain/flume-env.ps1")
  }->
  # log4j.properties
  file { '/etc/apache-flume/log4j.properties':
      ensure  => file,
      owner   => 'flume',
      group   => 'hadoop',
      mode    => '0644',
      content => template("techplatform/apache-flume/$mydomain/log4j.properties")
  }->
  # Source Event Monitor
  file { '/etc/apache-flume/flume_monit.py':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template("techplatform/apache-flume/flume_monit.py")
  }->
  # Flume console log from init script
  file { '/app/log/flume/flume.init.log':
    ensure  => file,
    owner   => 'flume',
    group   => 'hadoop',
    mode    => '0666',
  }->
  # Flume log
  file { '/app/log/flume/flume.log':
    ensure  => file,
    owner   => 'flume',
    group   => 'hadoop',
    mode    => '0666',
  }
  # init.d
  file { '/etc/init.d/flume-agent':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template("techplatform/apache-flume/flume-agent")
  }
  # java_home
  file { '/etc/profile.d/java.sh':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template("techplatform/apache-flume/java.sh")
  }->
  exec {'set-java_home':
    command => "/etc/profile.d/java.sh",
    user    => 'root',
    group   => 'root',
    require => File['/etc/profile.d/java.sh'],
  }
}
