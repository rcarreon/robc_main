
class yum::mysql5615 inherits yum::client {

  file { "/etc/yum.repos.d/mysql5615.repo":
    ensure  => present,
    require => File["/etc/yum.repos.d"],
    owner   => "root",
    group   => "root",
    mode    => "0644",
  }

  yumrepo { "mysql5615":
    descr    => "CentOS 6 MySQL 5.6.15",
    baseurl  => "http://yum.gnmedia.net/mysql/\$releasever/5615/",
  }
}
