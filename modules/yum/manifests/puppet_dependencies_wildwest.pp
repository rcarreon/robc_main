# mirror of puppetlabs puppet dependency repo
class yum::puppet_dependencies_wildwest inherits yum::client {

file { '/etc/yum.repos.d/puppet-dependencies-wildwest.repo':
  ensure  => present,
  require => File['/etc/yum.repos.d'],
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
}

yumrepo { 'puppet-dependencies-wildwest':
  descr    => 'wildwest repo for puppet dependency pkgs.',
  baseurl  => "http://yum.gnmedia.net/wildwest/puppet-dependencies/${::lsbmajdistrelease}/",
  enabled  => 1,
  gpgcheck => 0,
  require  => File['/etc/yum.repos.d/puppet-dependencies-wildwest.repo'],
  }
}
