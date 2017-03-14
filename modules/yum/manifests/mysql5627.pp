
class yum::mysql5627 inherits yum::client {

  file { "/etc/yum.repos.d/mysql5627.repo":
    ensure  => present,
    require => File["/etc/yum.repos.d"],
    owner   => "root",
    group   => "root",
    mode    => "0644",
  }

  yumrepo { "mysql5627":
    descr    => "CentOS 6 MySQL 5.6.27",
    baseurl  => "http://yum.gnmedia.net/mysql/\$releasever/5627/",
  }
}
