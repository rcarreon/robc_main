node 'rds1v-adops.ap.dev.lax.gnmedia.net' {
  include base
  include newrelic
  include newrelic::params
  include newrelic::sysmond
  include newrelic::nfsiostat
  $project='adops'

  common::nfsmount { '/app/log':
    device => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_rds_log/rds1v-adops.ap.dev.lax.gnmedia.net',
  }
  $redis_password = decrypt("6oKh1v706vXIEDp8XlTtZ8EraklUqhJxK7PbLVyNSaOn32VrjZPsh5dSsPKE\nACdY")
  redis::store { "adops": }
}
