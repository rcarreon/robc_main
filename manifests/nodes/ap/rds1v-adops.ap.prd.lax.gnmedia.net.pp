node 'rds1v-adops.ap.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
  include base
    $project="adops"

    common::nfsmount { '/app/log':
      device => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_prd_rds_log/rds1v-adops.ap.prd.lax.gnmedia.net',
    }
    $redis_password = decrypt("XMdvh6agu80aqsR34kP7DcDmU9MVL3cpYJIpE9OJZNnJCC/IqV+yFEJ/dB+j\ni+5u")
    redis::store { "adops": }
}
