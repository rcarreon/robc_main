class spark {
	
  file { '/app/log/spark':
    ensure  => directory,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0775',
    require => File['/app/log'],
  }

  #EXTRA DIRECTORIES 
  file { ['/app/data/eventlog']:
    ensure  => directory,
    owner   => hadoop,
    group   => hadoop,
    mode    => '0644',
  }

  nagios::service{'spark_errorlog':
      command              => 'check_nrpe!check_flumeerror',
      use                  => 'flume-services',
      max_check_attempts   => '1',
      notification_options => 'w,u,c,s',
      notes_url            => 'http://docs.gnmedia.net/wiki/Nagios-flumeerror',
  }

}