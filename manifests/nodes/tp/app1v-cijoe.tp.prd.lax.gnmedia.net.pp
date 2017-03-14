node 'app1v-cijoe.tp.prd.lax.gnmedia.net' {
      include newrelic
      include newrelic::params
      include newrelic::sysmond
      include newrelic::nfsiostat

    include base
        $project='ci'
        $httpd='cijoe'
        include common::app
        include jenkins::server

        mount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_shared/ci-shared",
                fstype  => "nfs",
                ensure  => "mounted",
                options => "nfsvers=3,tcp,noatime,rw,rsize=32768,wsize=32768,hard,intr,tcp",
                dump    => 0,
                pass    => 0,
                atboot  => true,
        }

        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_app_log/app1v-cijoe.tp.prd.lax.gnmedia.net",
        }
}
