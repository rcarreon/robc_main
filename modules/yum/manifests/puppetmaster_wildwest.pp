# mirror of puppetlabs puppet repos for puppet masters
class yum::puppetmaster_wildwest inherits yum::client {

file { '/etc/yum.repos.d/puppetmaster-wildwest.repo':
  ensure  => present,
  require => File['/etc/yum.repos.d'],
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
}

yumrepo { 'puppetmaster-wildwest':
  descr    => 'wildwest repo for puppet server pkgs.',
  baseurl  => "http://yum.gnmedia.net/wildwest/puppetmaster/${::lsbmajdistrelease}/",
  enabled  => 1,
  gpgcheck => 0,
  require  => File['/etc/yum.repos.d/puppetmaster-wildwest.repo'],
  }
}
