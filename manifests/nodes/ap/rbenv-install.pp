define rbenv::install(
  $user           = $title,
  $group          = $user,
  $home           = '',
  $root           = '',
  $ruby           = '',
  $rc             = '.bashrc',
  $timeout        = 100,
  $keep           = false,
  $bundler        = '',
  $configure_opts = '--disable-install-doc',
) {

  # Workaround http://projects.puppetlabs.com/issues/9848
  $home_path       = $home    ? { '' => "/home/${user}",        default => $home }
  $root_path       = $root    ? { '' => "${home_path}/.rbenv",  default => $root }
  $ruby_version    = $ruby    ? { '' => '2.2.2',                default => $ruby }
  $bundler_version = $bundler ? { '' => '1.10.6',               default => $bundler }

  $plugins_dir     = "${root_path}/plugins"
  $rbenvrc         = "${home_path}/.rbenvrc"
  $shrc            = "${home_path}/$rc"
  $rbenv_repo      = 'https://github.com/sstephenson/rbenv.git'
  $ruby_build_repo = 'https://github.com/sstephenson/ruby-build.git'

  $bin             = "${root_path}/bin"
  $shims           = "${root_path}/shims"
  $versions        = "${root_path}/versions"
  $global_path     = "${root_path}/version"
  $path            = [ $shims, $bin, '/bin', '/usr/bin' ]

  # Keep flag saves source tree after building.
  # This is required for some gems (e.g. debugger)
  $keep_flag = ''
  if $keep {
    $keep_flag = '--keep'
  }

  if ! defined( Class['rbenv::dependencies'] ) {
    require rbenv::dependencies
  }

  exec { "rbenv::clone ${user}":
    command => "git clone $rbenv_repo ${root_path}",
    user    => $user,
    group   => $group,
    creates => $root_path,
    path    => ['/bin', '/usr/bin', '/usr/sbin'],
    timeout => $timeout,
    cwd     => $home_path,
    require => Package['git'],
  }

  file { "rbenv::rbenvrc ${user}":
    path    => $rbenvrc,
    owner   => $user,
    group   => $group,
    content => template('adops/dot.rbenvrc.erb'),
    require => Exec["rbenv::clone $user"],
  }

  exec { "rbenv::shrc $user":
    command => "echo 'source ${rbenvrc}' >> ${shrc}",
    user    => $user,
    group   => $group,
    unless  => "grep -q rbenvrc ${shrc}",
    path    => ['/bin', '/usr/bin', '/usr/sbin'],
    require => File["rbenv::rbenvrc ${user}"],
  }

  file {$plugins_dir:
    ensure  => directory,
    path    => $plugins_dir,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    require => Exec["rbenv::clone ${user}"],
  }

  exec { 'ruby_build_clone':
    command     => "git clone ${ruby_build_repo} ${plugins_dir}/ruby-build",
    user        => $user,
    group       => $group,
    path        => ['/bin', '/usr/bin', '/usr/sbin'],
    timeout     => 100,
    cwd         => $home_path,
    creates     => "${plugins_dir}/ruby-build",
    logoutput   => 'on_failure',
    require     => File[$plugins_dir],
  }

  exec {'ruby_build_update':
    command     => 'git pull origin master',
    user        => $user,
    group       => $group,
    path        => ['/bin', '/usr/bin', '/usr/sbin'],
    timeout     => $timeout,
    cwd         => "${plugins_dir}/ruby-build",
    require     => Exec['ruby_build_clone'],
    logoutput   => 'on_failure',
    onlyif      => 'git remote update; if [ "$(git rev-parse @{0})" = "$(git rev-parse @{u})" ]; then return 0; else return 1; fi ]',
  }

  exec { "rbenv::compile ${user} ${ruby_version}":
    command     => "rbenv install ${keep_flag} ${ruby_version} && touch ${root_path}/.rehash",
    timeout     => 0,
    user        => $user,
    group       => $group,
    cwd         => $home_path,
    environment => ["RBENV_ROOT=${root_path}", "HOME=${home_path}", "CONFIGURE_OPTS=${configure_opts}"],
    creates     => "${versions}/${ruby_version}",
    path        => $path,
    logoutput   => 'on_failure',
    require     => Exec['ruby_build_update']
  }

  exec { "rbenv::rehash ${user} ${ruby_version}":
    command     => "rbenv rehash && rm -rf ${root_path}/.rehash",
    user        => $user,
    group       => $group,
    cwd         => $home_path,
    onlyif      => "[ -e '${root_path}/.rehash' ]",
    environment => ["HOME=${home_path}", "RBENV_ROOT=${root_path}"],
    path        => $path,
    logoutput   => 'on_failure',
    require     => Exec["rbenv::compile ${user} ${ruby_version}"]
  }

  exec { "rbenv::global ${ruby_version}":
    command     => "rbenv global ${ruby_version}",
    user        => $user,
    group       => $group,
    cwd         => $home_path,
    environment => ["HOME=${home_path}", "RBENV_ROOT=${root_path}"],
    path        => $path,
    logoutput   => 'on_failure',
    require     => Exec["rbenv::compile ${user} ${ruby_version}"]
  }

  exec { "rbenv::gem_install ${user} ${ruby_version}":
    command     => "gem install bundler -v ${bundler_version}",
    user        => $user,
    group       => $group,
    cwd         => $home_path,
    environment => ["HOME=${home_path}", "RBENV_ROOT=${root_path}"],
    path        => $path,
    logoutput   => 'on_failure',
  }
}
