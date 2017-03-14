class yum::mysql_common inherits yum::client {

    file {"/etc/yum.repos.d/mysql-common.repo":
        ensure  => absent,
        owner   => "root",
        group   => "root",
        mode    => "0644",
    }

#    yumrepo {"mysql-common":
#        baseurl => "http://yum.gnmedia.net/mysql/\$releasever/mysql-common",
#        descr   => "mysql common RPMs ( zrm agent ) - mysql version agnostic",
#        require => File["/etc/yum.repos.d/mysql-common.repo"],
#    }
}
