node 'app3v-build.ap.dev.lax.gnmedia.net' {
  include base
  $project='adops'
  include common::app

  include adops::packages
  # include adops::rbenv # Manually placing this for build, see below
  include git::client
  include ap::app::geminabox

  include newrelic
  include newrelic::params
  include newrelic::nfsiostat
  include newrelic::sysmond

  package {[
    'gcc','libcurl-devel', 'openssl-devel', 'zlib-devel','httpd-devel',
      'mod_ssl', 'gcc-c++','apr-devel','apr-util-devel','readline-devel',
      'patchutils','bison','mysql-devel','libffi-devel', 'tmux',
      'java-1.7.0-openjdk.x86_64', 'go-agent.noarch', 'ansible', 'cmake',
      'fakeroot', 'rpm-build', 'automake', 'autoconf'
      ]:
        ensure => present,
  }


  file {'/app/ansible':
    ensure  => directory,
    owner   => 'go',
    group   => 'go',
    mode    => '0755',
    require => File['/app'],
  }

  file {'/app/apbuild':
    ensure  => directory,
    owner   => 'apbuild',
    group   => 'apbuild',
    mode    => '0755',
    require => Mount['/app/apbuild'],
  }

  file {'/usr/local/bin/ap_sw.sh':
    ensure  => absent,
  }

  common::nfsmount { "/app/shared":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/build-shared",
  }

  common::nfsmount { "/app/log":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_log/app3v-build.ap.dev.lax.gnmedia.net",
  }

  common::nfsmount { "/app/software":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_app_shared/ap-software-prd",
  }

  common::nfsmount { "/app/apbuild":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/apbuild-home"
  }

  common::nfsmount { "/app/repos":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_yumrepos/yumoter/repos/adopsgem/6"
  }

  common::nfsmount { "/app/go-agent":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_go_agents/app3v-build.ap.dev.lax.gnmedia.net"
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
}
