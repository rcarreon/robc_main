node 'pxy2v-sdc.ao.stg.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
  $project='atomiconline'

  varnish::accelerates { 'stg.sherdog.com':
    version => 'c6_2_1_5_5',
  }

  common::nfsmount { '/pxy/log':
    device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_stg_pxy_log/pxy2v-sdc.ao.stg.lax.gnmedia.net",
  }
}
