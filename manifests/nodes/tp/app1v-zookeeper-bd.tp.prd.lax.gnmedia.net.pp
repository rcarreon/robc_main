node 'app1v-zookeeper-bd.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
  include base
  sudo::install_template { 'dba-root': }

  common::nfsmount { "/app/log":
    device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_log/app1v-zookeeper-bd.tp.prd.lax.gnmedia.net"
  }

  include zookeeper::install
  include zookeeper::cluster

}