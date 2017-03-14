
class yum::mysql5619 inherits yum::client {

  file { "/etc/yum.repos.d/mysql5619.repo":
    ensure  => present,
    require => File["/etc/yum.repos.d"],
    owner   => "root",
    group   => "root",
    mode    => "0644",
  }

  yumrepo { "mysql5619":
    descr    => "CentOS 6 MySQL 5.6.19",
    baseurl  => "http://yum.gnmedia.net/mysql/\$releasever/5619/",
    enabled => 0,
  }
}
