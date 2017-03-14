node 'uid1v-vtella.ao.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base

############################################################################
        $project="atomiconline"
        $username="vtella"
        include uidpb::devserver
        include uidpb::pbwb_uid_dbcred


############################################################################
##### Set up the server directory structures ###############################
############################################################################

        common::nfsmount { "/sql/data":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_vtella_ao_dev_lax_sbx/sql/data",
        }

        common::nfsmount { "/sql/binlog":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_vtella_ao_dev_lax_sbx/sql/binlog",
        }

        common::nfsmount { "/sql/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_vtella_ao_dev_lax_sbx/sql/log",
        }

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_vtella_ao_dev_lax_sbx/appshared",
        }

        common::nfsmount { '/app/ugcvb':
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_ao_lax_dev_app_ugc/vb-ugc/forums.playstationlifestyle.net",
        }

############################################################################

}
