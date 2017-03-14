node 'app1v-go.ap.dev.lax.gnmedia.net' {
  include base
  include newrelic
  include newrelic::params
  include newrelic::sysmond
  include newrelic::nfsiostat
  include git::client

  package { 'java-1.7.0-openjdk.x86_64':
    ensure => 'installed'
  }

  common::nfsmount { "/app/shared":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/build-shared",
  }

  common::nfsmount { "/app/repos":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_yumrepos/yumoter/repos/adopsgem/6",
  }

  file {'/app/shared/artifacts':
    ensure  => directory,
    owner   => 'go',
    group   => 'go',
    mode    => '0755',
    require => Mount['/app/shared'],
  }
}
