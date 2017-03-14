# puppet dependency rpms currently being tested
class yum::puppet_dependencies_beta inherits yum::client {

file { '/etc/yum.repos.d/puppet-dependencies-beta.repo':
  ensure  => present,
  require => File['/etc/yum.repos.d'],
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
}

yumrepo { 'puppet-dependencies-beta':
  descr    => 'beta repo for puppet server pkgs.',
  baseurl  => "http://yum.gnmedia.net/beta/puppet-dependencies/${::lsbmajdistrelease}/",
  enabled  => 1,
  gpgcheck => 0,
  require  => File['/etc/yum.repos.d/puppet-dependencies-beta.repo'],
  }
}
