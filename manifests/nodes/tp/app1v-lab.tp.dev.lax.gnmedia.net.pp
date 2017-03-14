node 'app1v-lab.tp.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    include yum::mysql5527

    $packages = ['httpd','php-mysql','php','php-common','php-pdo','subversion','mysql-server']

    package { $packages :
      ensure  => present,
    }

    file {"/root/.my.cnf":
        owner => "root",
        group => "root",
        mode    => 0600,
        content => "[client]\n user=root\n password=lab01\n",
    }

    common::nfsmount { "/mnt/apache":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_app_shared/lab-apache",
    }
    common::nfsmount { "/mnt/mysql":
        device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_app1v_lab_tp_dev_lax_data",
    }
    common::nfsmount { "/mnt/docroots":
        device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_app_shared/lab-docroots",
    }
    common::nfsmount { "/app/log":
      device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_dev_app_log/app1v-lab.tp.dev.lax.gnmedia.net",
    }

}

