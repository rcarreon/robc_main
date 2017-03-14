node 'app1v-dh.si.dev.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
        $project = "doublehelix"
        include common::app
        include doublehelix::fe_sites
        include doublehelix::commonconfig::dev
        #include doublehelix::nodejs
        sudo::install_template { 'app1v-dh-dev': }

        #nodejs::service{ "helloworld.evolvemediacorp.com":
        #    nodeappname => "helloworld",
        #    nodeappjs => "helloworld.js",
        #    nodeport => "81",
        #}


        common::nfsmount { "/app/shared":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_si_lax_dev_app_shared/dh-shared",
        }
        common::nfsmount { "/app/log":
                device  => "nfsA-netapp1.gnmedia.net:/vol/nac1a_si_lax_dev_app_log/app1v-dh.si.dev.lax.gnmedia.net",
        }
        common::nfsmount { "/app/tmp":
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_si_lax_dev_app_tmp/app1v-dh.si.dev.lax.gnmedia.net",
        }
        common::nfsmount { "/app/ugc":
                device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_si_lax_dev_app_ugc/dh-ugc",
        }
#        cron { "paparazzo_tmp_cleaner":
#            user        => "nobody",
#            command     => "tmpwatch 1h /app/tmp/paparazzo",
#            hour        => 1,
#            minute      => 1,
#        }


#        file {"/etc/yum.repos.d/test-epel-wildwest.repo":
#      ensure => file,
#      owner  => "root",
#      group  => "root",
#      mode   => "0644",
#      content => '[test-epel-wildwest]
#name=Gorillanation\'s TEST wildwest mirror of centos repos
#baseurl=http://yum.gnmedia.net/wildwest/epel/6/
#enabled=1
#gpgcheck=0
#',
#        }


#    file {"/etc/yum.repos.d/test-updates-wildwest.repo":
#      ensure => file,
#      owner  => "root",
#      group  => "root",
#      mode   => "0644",
#      content => '[test-updates-wildwest]
#name=Gorillanation\'s TEST wildwest mirror of centos repos
#baseurl=http://yum.gnmedia.net/wildwest/centos/6.4/updates/
#enabled=1
#gpgcheck=0
#',
#        }





}
