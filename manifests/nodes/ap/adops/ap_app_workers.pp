# Common packages, files and configs for AdOps workers
class ap::app::workers {

  package { 'git': ensure => installed }

  # files/directories
  file { '/app/log/workers':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Mount['/app/log'],
  }

  file { '/app/workers':
    ensure => directory,
    owner  => 'adops-deploy',
    group  => 'adops-deploy',
    mode   => '0755',
  }

  file {'/app/log/adops':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Mount['/app/log'],
  }
}
