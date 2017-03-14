# puppet server rpms currently being tested
class yum::puppetmaster_beta inherits yum::client {

file { '/etc/yum.repos.d/puppetmaster-beta.repo':
  ensure  => present,
  require => File['/etc/yum.repos.d'],
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
}

yumrepo { 'puppetmaster-beta':
  descr    => 'beta repo for puppet server pkgs.',
  baseurl  => "http://yum.gnmedia.net/beta/puppetmaster/${::lsbmajdistrelease}/",
  enabled  => 1,
  gpgcheck => 0,
  require  => File['/etc/yum.repos.d/puppetmaster-beta.repo'],
  }
}
