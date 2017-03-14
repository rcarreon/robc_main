class ap::app::geminabox {
  include httpd

  httpd::virtual_host{'ap-gems.evolvemediallc.com': uri => '/'}

  file{[
    '/app/software/ruby/geminabox',
    '/app/software/ruby/geminabox/tmp',
    '/app/software/ruby/geminabox/public'
  ]:
    ensure => directory,
    owner  => 'apbuild',
    group  => 'apbuild',
    mode   => '0755',
  }

  $gems = ["gem 'geminabox', '~> 0.13.0'"]
  file{'/app/software/ruby/geminabox/Gemfile':
    ensure  => file,
    owner   => 'apbuild',
    group   => 'apbuild',
    mode    => '0644',
    content => template('adops/gemfile.erb')
  }

  $geminabox_data_path = '/app/software/ruby/geminabox/public'
  file{'/app/software/ruby/geminabox/config.ru':
    ensure => file,
    owner  => 'apbuild',
    group  => 'apbuild',
    mode   => '0644',
   content => template('adops/geminabox_config.ru.erb'),
   require => File['/app/software/ruby/geminabox/public']
  }

  file{'/app/software/ruby/geminabox/.ruby-version':
    ensure  => file,
    owner   => 'apbuild',
    group   => 'apbuild',
    mode    => '0644',
    content => '2.1.1',
    require => File['/app/software/ruby/geminabox/public']
  }

  exec { 'bundle install --path=/app/software/ruby':
    cwd   => '/app/software/ruby/geminabox',
    user  => 'apbuild',
    path  => [
      '/usr/bin',
      '/usr/sbin',
      '/app/software/ruby/rbenv/shims',
      '/app/software/ruby/rbenv/bin'
    ],
    require => [
      File['/app/software/ruby/geminabox/Gemfile'],
      File['/app/software/ruby/geminabox/config.ru']
    ],
    notify => Service[httpd],
  }
}
