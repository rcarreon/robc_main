node 'uid1v-mrosas.ap.dev.lax.gnmedia.net' {
  include base
  $project='adops'

  ############################################################################
  ##### Set up the sql server directory structures ###########################
  ############################################################################
          
  common::nfsmount { "/sql/data":
        device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_mrosas_tp_dev_lax_sbx/sql/data",
  }

  common::nfsmount { "/sql/binlog":
        device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_mrosas_tp_dev_lax_sbx/sql/binlog",
  }

  common::nfsmount { "/sql/log":
        device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_mrosas_tp_dev_lax_sbx/sql/log",
  }

}
