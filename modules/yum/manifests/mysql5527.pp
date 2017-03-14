
class yum::mysql5527 inherits yum::client {

  file { "/etc/yum.repos.d/mysql5527.repo":
    ensure  => present,
    require => File["/etc/yum.repos.d"],
    owner   => "root",
    group   => "root",
    mode    => "0644",
  }

  yumrepo { "mysql5527":
    descr    => "CentOS 6 MySQL 5.5.27",
    baseurl  => "http://yum.gnmedia.net/mysql/\$releasever/5527/",
  }
}
