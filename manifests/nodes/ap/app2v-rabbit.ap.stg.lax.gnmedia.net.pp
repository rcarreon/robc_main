node 'app2v-rabbit.ap.stg.lax.gnmedia.net' {
  include base
  $project="adops"
  include common::app

  include newrelic
  include newrelic::params
  include newrelic::nfsiostat
  include newrelic::sysmond

  package { 'rabbitmq-server': ensure => installed }
  service { 'rabbitmq-server': ensure => running, enable => true }

  common::nfsmount { "/app/shared":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_stg_app_shared/rabbit-shared",
  }

  common::nfsmount { "/app/log":
    device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_stg_app_log/app2v-rabbit.ap.stg.lax.gnmedia.net",
  }
}
