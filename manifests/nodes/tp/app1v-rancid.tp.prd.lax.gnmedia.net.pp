node 'app1v-rancid.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
  include common::app
  # rancid class includes the cronjob module, which requires script_path
  $script_path='rancid_logrotate'
  include rancid
  include tftpserver

  common::nfsmount { "/app/shared":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_shared/rancid-shared",
  }

}
