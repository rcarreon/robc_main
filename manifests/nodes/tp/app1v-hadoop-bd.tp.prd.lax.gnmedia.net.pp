node 'app1v-hadoop-bd.tp.prd.lax.gnmedia.net' {
  include base
  include newrelic
  include newrelic::sysmond
  include newrelic::nfsiostat

  package { ['jdk1.8.0_45','tmux']:
    ensure => installed
  }

  sudo::install_template { 'dba-root': }

  common::nfsmount { '/app/data':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_data/hadoop',
  }

  common::nfsmount { '/app/log':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_log/app1v-hadoop-bd.tp.prd.lax.gnmedia.net',
  }

  common::nfsmount { '/app/shared':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_shared/hadoop-shared',
  }

  # files/directories
  file { '/app/data/hadoop':
    ensure  => directory,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0755',
    require => Mount['/app/data'],
  }

  file { '/app/log/hadoop':
    ensure  => directory,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0775',
    require => Mount['/app/log'],
  }

  # hive log dir needs stickky bit set, see:
  # https://cwiki.apache.org/confluence/display/Hive/GettingStarted#GettingStarted-HiveLogging
  file { '/app/log/hive':
    ensure  => directory,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '1755',
    require => Mount['/app/log'],
  }

  # hadoop configs
  file { '/etc/hadoop':
    ensure  => directory,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0755',
  }->
  # hadoop-env.sh
  file { '/etc/hadoop/hadoop-env.sh':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/env-hadoop.sh.erb')
  }->
  # core-site.xml
  # file { '/etc/hadoop/core-site.xml':
  #   ensure  => file,
  #   owner   => 'hadoop',
  #   group   => 'hadoop',
  #   mode    => '0644',
  #   content => template('techplatform/hadoop/core-site.xml.erb')
  # }->
  # hdfs-site.xml
  # file { '/etc/hadoop/hdfs-site.xml':
  #   ensure  => file,
  #   owner   => 'hadoop',
  #   group   => 'hadoop',
  #   mode    => '0644',
  #   content => template('techplatform/hadoop/hdfs-site.xml.erb')
  # }->
  # mapred-site.xml
  file { '/etc/hadoop/mapred-site.xml':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/mapred-site.xml.erb')
  }->
  # yarn-site.xml
  # file { '/etc/hadoop/yarn-site.xml':
  #   ensure  => file,
  #   owner   => 'hadoop',
  #   group   => 'hadoop',
  #   mode    => '0644',
  #   content => template('techplatform/hadoop/yarn-site.xml.erb')
  # }->
  # capacity-scheduler.xml
  file { '/etc/hadoop/capacity-scheduler.xml':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/capacity-scheduler.xml')
  }->
  # configuration.xsl
  file { '/etc/hadoop/configuration.xsl':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/configuration.xsl')
  }->
  # container-executor.cfg
  file { '/etc/hadoop/container-executor.cfg':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/container-executor.cfg')
  }->
  # hadoop-env.cmd
  # file { '/etc/hadoop/hadoop-env.cmd':
  #   ensure  => file,
  #   owner   => 'hadoop',
  #   group   => 'hadoop',
  #   mode    => '0644',
  #   content => template('techplatform/hadoop/hadoop-env.cmd')
  # }->
  # hadoop-metrics2.properties
  file { '/etc/hadoop/hadoop-metrics2.properties':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/hadoop-metrics2.properties')
  }->
  # hadoop-metrics.properties
  file { '/etc/hadoop/hadoop-metrics.properties':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/hadoop-metrics.properties')
  }->
  # hadoop-policy.xml
  file { '/etc/hadoop/hadoop-policy.xml':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/hadoop-policy.xml')
  }->
  # httpfs-env.sh
  # file { '/etc/hadoop/httpfs-env.sh':
  #   ensure  => file,
  #   owner   => 'hadoop',
  #   group   => 'hadoop',
  #   mode    => '0644',
  #   content => template('techplatform/hadoop/httpfs-env.sh')
  #}->
  # httpfs-log4j.properties
  file { '/etc/hadoop/httpfs-log4j.properties':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/httpfs-log4j.properties')
  }->
  # httpfs-signature.secret
  file { '/etc/hadoop/httpfs-signature.secret':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/httpfs-signature.secret')
  }->
  # kms-acls.xml
  file { '/etc/hadoop/kms-acls.xml':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/kms-acls.xml')
  }->
  # kms-env.sh
  file { '/etc/hadoop/kms-env.sh':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/kms-env.sh')
  }->
  # kms-log4j.properties
  file { '/etc/hadoop/kms-log4j.properties':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/kms-log4j.properties')
  }->
  # kms-site.xml
  file { '/etc/hadoop/kms-site.xml':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/kms-site.xml')
  }->
  # log4j.properties
  file { '/etc/hadoop/log4j.properties':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/log4j.properties')
  }->
  # mapred-env.cmd
  # file { '/etc/hadoop/mapred-env.cmd':
  #   ensure  => file,
  #   owner   => 'hadoop',
  #   group   => 'hadoop',
  #   mode    => '0644',
  #   content => template('techplatform/hadoop/mapred-env.cmd')
  # }->
  # mapred-env.sh
  file { '/etc/hadoop/mapred-env.sh':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/mapred-env.sh')
  }->
  # slaves
  # file { '/etc/hadoop/slaves':
  #   ensure  => file,
  #   owner   => 'hadoop',
  #   group   => 'hadoop',
  #   mode    => '0644',
  #   content => template('techplatform/hadoop/slaves')
  # }->
  # yarn-env.cmd
  # file { '/etc/hadoop/yarn-env.cmd':
  #   ensure  => file,
  #   owner   => 'hadoop',
  #   group   => 'hadoop',
  #   mode    => '0644',
  #   content => template('techplatform/hadoop/yarn-env.cmd')
  # }->
  # yarn-env.sh
  file { '/etc/hadoop/yarn-env.sh':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hadoop/yarn-env.sh')
  }


  # hive configs
  file { '/etc/hive':
    ensure  => directory,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0755',
  }->
  # hive-site.xml
  file { '/etc/hive/hive-site.xml':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0644',
    content => template('techplatform/hive/hive-site.xml')
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


  # profile.d settings for Hadoop
  file { '/etc/profile.d/hadoop.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('techplatform/hadoop/env-hadoop.sh.erb')
  }

  # profile.d settings for Hive
  file { '/etc/profile.d/hive.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('techplatform/hive/env-hive.sh.erb')
  }

  # INSTALL SOFTWARE
  $prefix = '/opt'
  $tmpdir = '/tmp'

  $installed = '/app/data/hadoop/HADOOP_INSTALLED'
  $installed_hive = '/app/data/hadoop/HIVE_INSTALLED'
  
  # install hadoop
  exec {'retrieve-hadoop':
    command => 'wget http://apache.webxcreen.org/hadoop/common/hadoop-2.7.0/hadoop-2.7.0.tar.gz',
    cwd     => $tmpdir,
    creates => "${tmpdir}/hadoop-2.7.0.tar.gz",
    user    => 'hadoop',
    group   => 'hadoop',
    notify  => Exec['extract-hadoop'],
    unless  => "test -f ${installed}",
  }->
  exec {'extract-hadoop':
    command => 'tar xvzf hadoop-2.7.0.tar.gz',
    cwd     => $tmpdir,
    creates => "${tmpdir}/hadoop-2.7.0",
    user    => 'hadoop',
    group   => 'hadoop',
    require => Exec['retrieve-hadoop'],
    notify  => Exec['move-hadoop'],
    unless  => "test -f ${installed}",
  }->
  exec {'move-hadoop':
    command => "mv -v ${tmpdir}/hadoop-2.7.0/ ${prefix}/",
    cwd     => $tmpdir,
    user    => 'root',
    group   => 'root',
    creates => "${prefix}/hadoop-2.7.0",
    require => Exec['extract-hadoop'],
    unless  => "test -f ${installed}",
  }->
  file {'/opt/hadoop':
    ensure  => link,
    target  => 'hadoop-2.7.0',
    require => Exec['move-hadoop'],
  }->
  exec {'set-hadoop-installed':
    command => "touch ${installed}",
    cwd     => $tmpdir,
    user    => 'root',
    group   => 'root',
    creates => "${installed}",
    require => File['/opt/hadoop'],
  }

  # install hive
  exec {'retrieve-hive':
    command => 'wget http://apache.webxcreen.org/hive/stable/apache-hive-1.2.1-bin.tar.gz',
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

  # CRON JOBS
  file { '/usr/local/bin/cron-hdfs-snapshot':
    ensure  => file,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0755',
    content => template('techplatform/hadoop/cron-hdfs-snapshot')
  }->
  cron { 'hdfs-snapshots':
    ensure    => present,
    user      => 'hadoop',
    command   => '/usr/local/bin/cron-hdfs-snapshot >> /app/log/hadoop/hdfs-snapshot.log',
    hour      => '01',
    minute    => '00',
    require   => Exec['set-hadoop-installed'],
  }

}
