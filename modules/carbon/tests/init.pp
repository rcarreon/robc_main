mount { "/app/log":
        device  => "$nfs_ip:/vol/nfs1_tp_lax_prd_app_log/app1v-carbon.tp.prd.lax.gnmedia.net",
        fstype  => "nfs",
        ensure  => "mounted",
        options => "nfsvers=3,tcp,noatime,rw,rsize=32768,wsize=32768,hard,intr,tcp",
        dump    => 0,
        pass    => 0,
        atboot  => true,
}

include carbon