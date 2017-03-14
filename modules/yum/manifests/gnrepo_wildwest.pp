class yum::gnrepo_wildwest inherits yum::client {

file { "/etc/yum.repos.d/gnrepo-wildwest-tmp.repo":
  ensure  => present,
  require => File["/etc/yum.repos.d"],
  owner   => "root",
  group   => "root",
  mode    => "0644",
}

yumrepo { "gnrepo-wildwest-tmp":
  descr    => "Public CentOS Packages",
  baseurl  => "http://yum.gnmedia.net/wildwest",
  enabled  => 1,
  gpgcheck => 0,
  require  => File["/etc/yum.repos.d/gnrepo-wildwest-tmp.repo"],
  }
}
