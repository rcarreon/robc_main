node 'pxy1v-sdc.ao.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
  $project='atomiconline'

  varnish::accelerates { 'dev.sherdog.com':
    version => 'c6_2_1_5_5',
  }

  common::nfsmount { '/pxy/log':
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ao_lax_dev_pxy_log/pxy1v-sdc.ao.dev.lax.gnmedia.net",
  }
}
