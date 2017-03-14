class yum::epel_wildwest inherits yum::client {

# this is the wild wild west repo
# you should not need to use the wild wild west repo
file { "/etc/yum.repos.d/epel-wildwest-tmp.repo":
  ensure  => present,
  require => File["/etc/yum.repos.d"],
  owner   => "root",
  group   => "root",
  mode    => "0644",
}

yumrepo { "epel-wildwest-tmp":
  descr    => "epel wild wild west.",
  baseurl  => "http://yum.gnmedia.net/wildwest/epel/\$releasever/",
  enabled  => 0,
  gpgcheck => 0,
  require  => File["/etc/yum.repos.d/epel-wildwest-tmp.repo"],
  }
}
