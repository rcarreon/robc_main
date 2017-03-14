node 'rds2v-adops.ap.stg.lax.gnmedia.net' {
  include base
  $project="adops"

  include newrelic
  include newrelic::params
  include newrelic::nfsiostat
  include newrelic::sysmond

  common::nfsmount { '/app/log':
    device => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_stg_rds_log/rds2v-adops.ap.stg.lax.gnmedia.net',
  }
  $redis_password = decrypt("E/VslUSZ6Jbo7mxb6Yp8jt6cE1o8fXRLwynDQeQxnkP42WRACYLA4rbaT+N3\nckWb")
  redis::store { "adops": }
}
