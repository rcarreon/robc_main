# flume
class flume::base {
  
  nagios::service{'flumeerrorlog':
      command              => 'check_nrpe!check_flumeerror',
      use                  => 'flume-services',
      max_check_attempts   => '1',
      notification_options => 'w,u,c,s',
      notes_url            => 'http://docs.gnmedia.net/wiki/Nagios-flumeerror',
  }

  if ($::architecture == 'x86_64') {
      $nagpluglibdir = 'lib64'
  } else {
      $nagpluglibdir = 'lib'
  }

  file { '/app/data/flume':
    ensure  => directory,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0775',
  }    

  file { '/app/log/flume':
    ensure  => directory,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0775',
  }    

  file { '/opt/hadoop':
    ensure  => directory,
    owner   => 'hadoop',
    group   => 'hadoop',
    mode    => '0775',
  }    

}
