# WebServer settings for pixel tracking
class pixel::base {

  file { '/etc/sysconfig/httpd':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("pixel/httpd_sysconfig.erb")
  }

  class {'security::flume_nofile':
      hard_file_limit => 16384,
      soft_file_limit => 8192,
  }

  file { '/etc/sysctl.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('techplatform/apache-flume/og.prd.lax.gnmedia.net/sysctl.conf.erb'),
    notify => Exec['refresh-kernel'], 
  }

  exec {'refresh-kernel': 
    command  => 'sysctl -p', 
    path => '/sbin/:/bin/',
    refreshonly => true
  } 

}