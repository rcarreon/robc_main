class ap::app::common_mounts {
  common::nfsmount { '/app/shared':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/adops-new-shared',
  }

  common::nfsmount { '/app/log':
    device  => 'nfsB-netapp1.gnmedia.net:/vol/nac1b_ap_lax_dev_app_log/app2v-adops.ap.dev.lax.gnmedia.net',
  }

  common::nfsromount { '/app/software':
    device  => 'nfsA-netapp1.gnmedia.net:/vol/nac1a_ap_lax_dev_app_shared/ap-software-dev',
  }
}
