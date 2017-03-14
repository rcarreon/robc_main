node 'uid1v-mdillon.ao.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat

    $username="mdillon"
    $project="atomiconline"
    include base
    include uidpb::devserver
    include uidpb::pbwb_uid_dbcred
    include uidpb::mcsphinx
    include php::timezone 

    class {"mysqld56": template=>"56-default-uid",sqlclass=>"unsupported"}

############################################################################
##### Set up the sql server directory structures ###########################
############################################################################

    common::nfsmount { "/sql/data":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_mdillon_ao_dev_lax_sbx/sql/data",
    }

    common::nfsmount { "/sql/binlog":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_mdillon_ao_dev_lax_sbx/sql/binlog",
    }

    common::nfsmount { "/sql/log":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_mdillon_ao_dev_lax_sbx/sql/log",
    }

    common::nfsmount { "/app/shared":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_uid1v_mdillon_ao_dev_lax_sbx/appshared",
    }



}
