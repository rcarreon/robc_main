node 'app2v-xcat.tp.prd.lax.gnmedia.net' {
    include newrelic
    include newrelic::params
    include newrelic::sysmond
    include newrelic::nfsiostat
    include base
    include aceman
    include hi5
    include sendmail::relay
    include sqlcopy
    include mock
    include rsyslog::locallogs
    include route53

    package { ["subversion", "perl-Net-IP", "perl-Sys-Virt", "perl-JSON","perl-Expect",
        "compat-libtermcap", "automake","autoconf","rpm-build","perl-DBD-MySQL",
        "rubygems","tmux","git","ack", "virt-top", "perl-NetApp", "perl-Text-ASCIITable","perl-IO-Stty", "vsftpd"]:
        ensure => latest,
    }

    file { "/usr/local/bin/netapp_report":
        owner  => root,
        group  => root,
        mode   => 755,
        source => "puppet:///modules/common/netapp_report",
    }
    
    file { "/etc/xinetd.d/rvmloadtojson":
        owner  => root,
        group  => root,
        mode   => 644,
        source => "puppet:///modules/common/rvmloadtojson.xinetd",
        notify => Service["xinetd"],
    }

    cron { "xcatdbbackup":
        user    => root,
        ensure  => absent, #temp change
        hour    => "*",
        minute  => 10,
        weekday => "*",
        command => "/usr/local/bin/xcat-backupdb",
    }

    cron { "metalfreeram":
        user    => root,
        ensure  => absent, # enabled on app1v-xcat
        hour    => "5",
        minute  => "1",
        weekday => "1",
        command => "/usr/local/bin/metalfreeram",
    }
    cron { "pmacreateconfig":
       ensure  => absent, # enabled on app1v-xcat
       command => "/usr/local/bin/pmacreateconfig 2>&1",
       user    => 'root',
       minute  => [0, 30]
    }

    common::nfsmount{ "/mnt/decom":
        device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_decom",
    }
    common::nfsmount{ "/install":
        device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_osinstall",
    }
    common::nfsmount{ "/var/log":
        device => "nfsA-netapp1.gnmedia.net:/vol/nac1a_tp_lax_prd_xcatvarlog/app2v-xcat.tp.prd.lax.gnmedia.net",
    }

    cron { "optpathchecker":
        user => root,
        ensure  => absent, # enabled on app1v-xcat
        hour => "6",
        minute => "10",
        weekday => "*",
        command => "/usr/local/bin/optpathchecker",
        environment => "MAILTO=sysadmins@gorillanation.com",
    }

    cron { "dbsnapvaulter":
        user => root,
        ensure  => absent, # enabled on app1v-xcat
        hour => "2",
        minute => "10",
        weekday => "*",
        command => "/usr/local/bin/dbsnapvaulter",
        environment => "MAILTO=sysadmins@gorillanation.com",
    }

    cron { "nfs-exports-backup":
        user => root,
        ensure  => absent, # enabled on app1v-xcat
        hour => "6",
        minute => "10",
        weekday => "*",
        command => "/usr/local/bin/nfs-exports-backup",
        environment => "MAILTO=sysadmins@gorillanation.com",
    }

}
