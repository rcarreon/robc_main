node 'app1v-piwik.si.dev.lax.gnmedia.net' {
  include base
  include newrelic
  include newrelic::params
  include newrelic::sysmond
  include newrelic::nfsiostat

  common::nfsmount { '/app/shared':
    device => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_si_lax_dev_app_shared/piwik-shared',
  }

  common::nfsmount { '/app/log':
    device => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_si_lax_dev_app_log/app1v-piwik.si.dev.lax.gnmedia.net',
  }
}
