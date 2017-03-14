node 'app1v-build.ap.prd.lax.gnmedia.net' {
  include base
  $project = 'adops'
  include adops::build

  include git::client

  include newrelic
  include newrelic::params
  include newrelic::nfsiostat
  include newrelic::sysmond

  package {
    [
      'java-1.7.0-openjdk.x86_64',
      'go-agent.noarch',
      'GeoIP'
    ]:
    ensure => 'installed',
  }

  common::nfsmount { '/app/shared':
    device => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_shared/build-shared',
  }

  common::nfsmount { '/app/software':
    device => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_shared/ap-software-prd',
  }

  common::nfsmount { '/app/log':
    device => 'nfsA-netapp1.gnmedia.net:/vol/nac1b_ap_lax_prd_app_log/app1v-build.ap.prd.lax.gnmedia.net',
  }

  common::nfsmount { "/app/go-agent":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_go_agents/app1v-build.ap.prd.lax.gnmedia.net"
  }

  # On build we want to force users on /app/software's version of rbenv
  file { '/etc/profile.d/rbenv.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "export RBENV_ROOT='/app/software/ruby/rbenv'\nexport PATH=\"\${RBENV_ROOT}/bin:\${PATH}\"\neval \"$(rbenv init -)\"",
    require => Mount['/app/software'],
  }

  file {'/app/shared/cap':
    ensure  => directory,
    owner   => 'go',
    group   => 'go',
    mode    => '0755',
    require => Mount['/app/shared'],
  }->
  file {'/app/shared/tmp':
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

  class { 'ap::app::geoip::config':
    config_path => '/app/shared/tmp'
  }
}
