node 'app2v-build.ap.dev.lax.gnmedia.net' {
  include base
  $project='adops'
  include common::app

  include adops::packages
  include adops::rbenv
  #include adops::rbenv # Manually placing this for build, see below
  include git::client
  include ap::app::geminabox

  include newrelic
  include newrelic::params
  include newrelic::nfsiostat
  include newrelic::sysmond

  package {
    [
      'GeoIP',
      'tmux'
    ]:
      ensure => present,
  }

  package {[
    'gcc',
    'gcc-c++',
    'apr-devel',
    'apr-util-devel',
    'libcurl-devel',
    'openssl-devel',
    'zlib-devel',
    'httpd-devel',
    'mod_ssl',
    'readline-devel',
    'patchutils',
    'bison',
    'mysql-devel',
    'libffi-devel',
    'cmake',
    'fakeroot',
    'rpm-build'
    ]:
      ensure => present,
  }

  file {'/app/apbuild':
    ensure  => directory,
    owner   => 'apbuild',
    group   => 'apbuild',
    mode    => '0755',
    require => Mount['/app/apbuild'],
  }

  # For software promotion
  file {'/usr/local/bin/ap_sw.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('adops/ap_sw.sh.erb'),
  }

  file {'/usr/local/bin/promote_software_build_to_dev.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('adops/promote_software_build_to_dev.sh.erb'),
  }

  common::nfsmount { "/app/shared":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/build-shared",
  }

  common::nfsmount { "/app/log":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_log/app2v-build.ap.dev.lax.gnmedia.net",
  }

  common::nfsmount { "/app/software":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/ap-software-build",
  }

  common::nfsmount { "/app/apbuild":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/apbuild-home"
  }

  common::nfsmount { "/app/go-agent":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_go_agents/app2v-build.ap.dev.lax.gnmedia.net"
  }


  file {'/app/shared/cap':
    ensure  => directory,
    owner   => 'go',
    group   => 'go',
    mode    => '0755',
    require => Mount['/app/shared'],
  }

  # New rake wrapper for crons
  file {"/usr/local/bin/ap-deploy":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('adops/ap-deploy'),
  }

  file {'/opt/adops':
    ensure => directory,
    owner  => 'go',
    group  => 'go',
    mode   => '0755',
  }

  # allows the go server to test geoip builds
  class { 'ap::app::geoip::config':
    config_path => '/app/shared/tmp'
  }
}
