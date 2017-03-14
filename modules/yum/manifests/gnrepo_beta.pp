# beta repo for GN RPMs
class yum::gnrepo_beta inherits yum::client {

file { "/etc/yum.repos.d/gnrepo-beta-tmp.repo":
  ensure  => present,
  require => File["/etc/yum.repos.d"],
  owner   => "root",
  group   => "root",
  mode    => "0644",
}

yumrepo { "gnrepo-beta-tmp":
  descr    => "STAGING Gorilla Nation local CentOS Packages",
  baseurl  => "http://yum.gnmedia.net/beta/gnrepo/$lsbmajdistrelease",
  enabled  => 1,
  gpgcheck => 0,
  require  => File["/etc/yum.repos.d/gnrepo-beta-tmp.repo"],
  }
}
