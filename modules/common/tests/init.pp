# test ALL THE THINGS #SOME OF THE TIME
# test phab comment
include common::app
common::ugcmount{ "/app/ugc":
    device => "fake.netapp1.gnmedia.net:/vol/nac1a_noop_lax_dev_app_shared/wp-ugc",
}
common::nfsmount { "/sql/data":
    device  => "fake.netapp1.gnmedia.net:/vol/nac1a_uid1v_cchavez_noop_dev_lax_sbx/sql/data",
}
common::nfsromount {"/mnt/noop/stg/odd":
    device => "fake.netapp1.stg.lax.gnmedia.net:/vol/nac1a_noop_lax_stg_app_log/",
}   
common::lvmount {"/oops":
    vgname => "fake_netapp1_iscsi",
    lvname => "not_our_svnrepos",
}  
