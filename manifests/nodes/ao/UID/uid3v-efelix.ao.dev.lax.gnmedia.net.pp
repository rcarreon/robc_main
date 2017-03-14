node 'uid3v-efelix.ao.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
	    include base

############################################################################
        $project="atomiconline"
        $username="efelix"
        include uidpb::devserver
        include uidpb::pbwb_uid_dbcred



############################################################################
##### Set up the mounted directory structures ##############################
############################################################################

        common::nfsmount { "/sql/data":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_efelix_ao_dev_lax_sbx/sql/data",
        }

        common::nfsmount { "/sql/binlog":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_efelix_ao_dev_lax_sbx/sql/binlog",
        }

        common::nfsmount { "/sql/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_efelix_ao_dev_lax_sbx/sql/log",
        }

        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_efelix_ao_dev_lax_sbx/appshared",
        }



}
