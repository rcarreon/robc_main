# Common packages, files and configs for GeoIP
class ap::app::geoip($rails_env = 'production') {
  include common::app
  include httpd
  include adops::rbenv
  include adops::rubybase
  include adops::passenger4

  # files/directories
  file { [
      '/app/shared/docroots/geoip.evolvemediallc.com',
      '/app/shared/docroots/geoip.evolvemediallc.com/shared',
      '/app/shared/docroots/geoip.evolvemediallc.com/shared/config',
      '/app/shared/docroots/geoip.evolvemediallc.com/shared/data',
      '/app/shared/docroots/geoip.evolvemediallc.com/releases',
      '/app/shared/docroots/geoip.evolvemediallc.com/repo',
    ]:
    ensure  => directory,
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
    mode    => '0755',
  }

  file { '/app/log/geoip':
    ensure  => directory,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
  }

  file { '/app/log/geoip/adops-deploy':
    ensure  => directory,
    mode    => '0755',
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
    require => File['/app/log/geoip'],
  }

  file { '/app/log/geoip/apache':
    ensure  => directory,
    mode    => '0755',
    owner   => 'apache',
    group   => 'apache',
    require => File['/app/log/geoip'],
  }

  # GeoIP Config stuff
  # $adops_GeoIP_License = decrypt('L0K3qxm/4u6FIVQ5sNvETA==')
  # $adops_GeoIP_UserID = '32923'
  # $adops_GeoIP_ProductID = '106'

  # file { '/app/shared/docroots/geoip.evolvemediallc.com/shared/config/GeoIP.conf':
  #   ensure  => present,
  #   content => "LicenseKey ${adops_GeoIP_License}\nUserId ${adops_GeoIP_UserID}\nProductIds ${adops_GeoIP_ProductID}",
  #   owner   => 'adops-deploy',
  #   group   => 'apache',
  #   mode    => '0644',
  # }

  #cron { 'geoip_update':
  #  ensure  => present,
  #  user    => 'adops-deploy',
  #  minute  => '12',
  #  hour    => '23',
  #  weekday => '3',
  #  command => '/usr/bin/geoipupdate -f /app/shared/docroots/geoip.evolvemediallc.com/shared/config/GeoIP.conf -d /app/shared/docroots/geoip.evolvemediallc.com/shared/data',
  #}


  file {'/app/shared/docroots/geoip.evolvemediallc.com/shared/config/geoip.yml':
    content => 'db_path: /app/shared/docroots/geoip.evolvemediallc.com/shared/data/GeoIP.dat',
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
    mode    => '0644',
  }

# Secrets
  $rails_env_name   = $rails_env
  $rails_secret_key = decrypt('SJP+X9d667hCWlHcgzQPdUuANdyzS9MxDWCjDaAz3dKN9Go4GrdyFB+Up0LvCMea+B0gC//AB10OFvK1OIGvpc2k5UGaNA3+kACXq7qwI2kk1WyDp8tvXfeRnuyO7fid6o9omc50XRhqO+qnxAVQQeAZ7J7PHQ07uwP2UN8IgI+1Ohwo1yrsgGvMB/0Kc+Vb')
  file {'/app/shared/docroots/geoip.evolvemediallc.com/shared/config/secrets.yml':
    content => template('adops/rails_secrets.yml.erb'),
    owner   => 'adops-deploy',
    group   => 'adops-deploy',
    mode    => '0755',
  }
}
